#!/bin/sh

set -e

mkdir -p ~/flamegraphs
now=$(date +"%m_%d_%Y_%H:%M:%S")

remote_file=$1
echo $remote_file

echo scp...
miba_ssh_session -a -- scp -rp "$remote_file" ~/flamegraphs/$now.perf.data

echo perf script...
perf script -i ~/flamegraphs/$now.perf.data | \
  ~/FlameGraph/stackcollapse-perf.pl > ~/flamegraphs/$now.out.perf-folded

echo flamegraph.pl...
~/FlameGraph/flamegraph.pl ~/flamegraphs/$now.out.perf-folded > \
  ~/flamegraphs/$now.perf.svg

echo cp...
cp ~/flamegraphs/$now.perf.svg perf.svg

echo google-chrome...
google-chrome perf.svg
