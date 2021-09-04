import argparse
import re
import signal
import subprocess as sp
import time

from pathlib import Path
from prometheus_client import start_http_server, Gauge, Enum, Info

PLOT_COUNT = Gauge("plot_count", "Total chia plots")
LEGACY_PLOT_COUNT = Gauge("legacy_plot_count", "Count of legacy chia plots")
DISK_TOTAL = Gauge("disk_total_bytes", "Total disk space available")
DISK_USED = Gauge("disk_used_bytes", "Total disk space used")
DISK_FREE = Gauge("disk_free_bytes", "Total disk space free")

def parse_args():
    parser = argparse.ArgumentParser(description="This is a prometheus exporter for chia harvesters")
    parser.add_argument("-d", "--plot-dir", default="/mnt/plots", help="This is the root directory of chia plots on the harvester")
    parser.add_argument("-p", "--port", default=9825, help="Port to listen on for the exporter")
    parser.add_argument("--legacy-re", default="/legacy/", help="This is a regular expression which if matched counts plots as legacy plots\n" +
                        "Usefull when changing plot formats or migrating to poolable plots")
    parser.add_argument("-v", "--verbose", default=0, action='count')

    return parser.parse_args()

def count_plots(path, legacy):
    plots = 0
    legacy_plots = 0
    for file in path.rglob('*.plot'):
        plots += 1
        if legacy.search(str(file)):
            legacy_plots += 1
    return plots, legacy_plots

def check_disk_space(plot_path):
    plot_path = plot_path.absolute()
    df = sp.check_output(['df'], encoding='utf-8')
    total_used = 0
    total_free = 0
    for line in df.split('\n')[1:]:
        if line.strip() == '':
            continue
        dev, blocks, used, avail, use_perc, mnt = line.split()
        if mnt.startswith(str(plot_path)) or str(plot_path).startswith(mnt):
            total_used += int(used) * 1024
            total_free += int(avail) * 1024
    return total_used, total_free, total_used + total_free


running = True

def stop_handler(sig, frame):
    global running

    running = False
    print('stopping...')

if __name__ == "__main__":
    # Start the server and expose metrics
    args = parse_args()
    start_http_server(args.port)
    signal.signal(signal.SIGINT, stop_handler)
    legacy_re = re.compile(args.legacy_re)
    plot_dir = Path(args.plot_dir)
    while running:
        plots, legacy = count_plots(plot_dir, legacy_re)
        PLOT_COUNT.set(plots)
        LEGACY_PLOT_COUNT.set(legacy)
        disk_used, disk_free, disk_total = check_disk_space(plot_dir)
        DISK_TOTAL.set(disk_total)
        DISK_FREE.set(disk_free)
        DISK_USED.set(disk_used)
        if args.verbose > 0:
            print(f'plots: {plots}, legacy-plots: {legacy}')
            print(f'total disk: {disk_total*1e-12} TB, free_disk: {disk_free*1e-12} TB, used_disk: {disk_used*1e-12} TB')
        time.sleep(15)