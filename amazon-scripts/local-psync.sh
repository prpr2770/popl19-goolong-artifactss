#!/bin/bash
source `dirname $0`/deps

# trap CTRL-C input, and kill every process created
trap "pkill -P $$; sleep 1; exit 1;" INT

t=12

echo "ID:$1 ### running 1 LV replica for $t seconds"

pkill -9 -f java

java -cp ${cp} example.PerfTest3 -id $1 --conf conf.xml --packetSize 4096 $* 2>/dev/null &

sleep $((t + 2))

echo "stopping ..."
pkill -P $$
sleep 1
