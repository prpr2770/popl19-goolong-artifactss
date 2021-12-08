#!/bin/zsh

blue()  { print -P "%F{blue}%B$@%b%f" }
green() { print -P "%F{green}%B$@%b%f" }
red()   { print -P "%F{red}%B$@%b%f" }

THIS_DIR=${0:A:h}

# QS=(1000 5000 10000)
# WS=(0 25 50 75 100)

QS=(2000 8000)
WS=(0 100)

for q in ${QS[@]}; do
	for w in ${WS[@]}; do
		blue "running:" $@ -q $q -w $w
		$THIS_DIR/multi-run.sh $@ -q $q -w $w
	done
done

