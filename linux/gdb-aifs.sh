#!/bin/bash

P=$(basename $0)
D=$(cd $(dirname $0) && pwd)

set -e
cd ../../linux-aifs-build-new

gdb -x  $D/debug-kernel.gdb
