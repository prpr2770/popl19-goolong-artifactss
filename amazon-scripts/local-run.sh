#!/bin/zsh

zparseopts -D -E -- \
	b=BATCH \
	c:=CONFLICT_PERC q:=REQUEST_COUNT r:=ROUND_COUNT w:=WRITE_PERC \
	-client=CLIENT \
	h=HELP -help=HELP

if [[ $? -ne 0 ]]; then
	echo "argument parsing failed !" >&2
	exit 1
fi

if [[ $# -ne 1 ]]; then
	echo "usage: $0 <instance no> (btw 1 & N)"
	exit 1
fi

source info.sh

if [[ 1 -le $1 && $1 -le ${#IPS} ]]; then
	I=$1
else
	echo "given index $1 is not within bounds" >&2
	exit 1
fi

IPS_PORTS=( )
for (( i=1; i<=${#IPS}; i++ )); do
	IPS_PORTS[$i]="${IPS[$i]}:$DEFAULT_PORT"
done

if [[ -z "$CLIENT" ]]; then
	~/gochai/bin/multipaxos \
		$BATCH \
		-addr "${IPS[$I]}:$DEFAULT_PORT" \
		-id $((I - 1)) \
		-log "log${I}.txt" \
		${IPS_PORTS[@]}
else
	~/gochai/bin/client -log 'logc' \
		$CONFLICT_PERC $REQUEST_COUNT $ROUND_COUNT $WRITE_PERC \
		${IPS_PORTS[@]}
fi
