#!/bin/bash
set -e
CURDIR=$(cd $(dirname $0); pwd)

source $CURDIR/env.sh

repo=("grpc" "kitex")
ports=(8000 8006)

ip=${IP:-"127.0.0.1"}

# build
source $CURDIR/build_grpc.sh

# benchmark
for b in ${body[@]}; do
  for c in ${concurrent[@]}; do
    for ((i = 0; i < ${#repo[@]}; i++)); do
      rp=${repo[i]}
      addr="${ip}:${ports[i]}"

      # run client
      echo "Client [$rp] running with [$taskset_client]"
      $cmd_client $output_dir/bin/${rp}_bencher -addr="$addr" -b=$b -c=$c -n=$n --sleep=$sleep | $tee_cmd
    done
  done
done

finish_cmd
