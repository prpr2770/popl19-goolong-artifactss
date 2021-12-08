#!/bin/zsh

zparseopts -D -E -- \
	e=EGALITARIAN \
	h=HELP -help=HELP

if [[ -n "$HELP" ]]; then
	cat <<EOF
usage:
  -e: run egalitarian paxos
EOF
	exit 0
fi

blue()  { print -P "%F{blue}%B$1%b%f" }
green() { print -P "%F{green}%B$1%b%f" }
red()   { print -P "%F{red}%B$1%b%f" }

# trap CTRL-C input, and kill every process created
trap "pkill -P $$; sleep 1; exit 1;" INT

ADDR="127.0.0.1"
PORTS=( "7070" "7071" "7072" )

blue "starting master ..."

bin/master &

sleep 1

blue "starting ${#PORTS} servers ..."

for ((i = 1; i <= ${#PORTS}; i++)); do
	bin/server $EGALITARIAN -port "$PORTS[$i]" &
done

sleep 5

blue "starting client ..."

bin/client

pkill -P $$
sleep 1

green "DONE !"

