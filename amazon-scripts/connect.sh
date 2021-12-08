#!/bin/zsh

zparseopts -D -E -- \
	i:=INSTANCE_NO -instance:=INSTANCE_NO \
	h=HELP -help=HELP

if [[ -n "$HELP" ]]; then
	cat <<EOF
usage:
  -i, --instance <N> : instance number to connect (1 <= N <= 3)
EOF
	exit 0
fi

source ${0:A:h}/info.sh

if [[ -z "$INSTANCE_NO" ]]; then
	I=1
else
	N=${INSTANCE_NO[2]}
	if [[ 1 -le $N && $N -le ${#IPS} ]]; then
		I=$N
	else
		echo "given index $N is not within bounds" >&2
		exit 1
	fi
fi

ssh -i key-pair.pem $EC2_USERNAME@${IPS[$I]} $@

