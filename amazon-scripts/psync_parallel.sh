#!/bin/zsh

DATE=$(date +'%Y%m%d_%H%M')

{
for (( i=0; i<10; i++ )); do
	seq 3 | parallel --line-buffer './test_psync.sh --test {}'
done
} | tee ${0:A:h}/logs/${DATE}_psync.txt

