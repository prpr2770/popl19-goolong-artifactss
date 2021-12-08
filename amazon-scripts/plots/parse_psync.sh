#!/bin/zsh

if [[ $# -ne 1 ]]; then
	echo "usage: ${0:t} <psync log>" >&2
	exit 1
fi

FILENAME=$1

echo -n "average throughput: "

grep throughput $FILENAME |\
	awk '{ sum += $9; n += 1} END {print sum * 1.0 / n}'
