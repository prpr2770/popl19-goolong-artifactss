#!/bin/zsh
# vim: set foldmethod=marker:

# argument parsing {{{
zparseopts -D -E -- \
	-setup=SETUP -kill=KILL \
	b=BATCH c:=CONFLICT_PERC q:=REQUEST_COUNT r:=ROUND_COUNT w:=WRITE_PERC \
	h=HELP -help=HELP

if [[ $? -ne 0 ]]; then
	echo "argument parsing failed !" >&2
	exit 1
fi

if [[ -n "$HELP" ]]; then
	cat <<EOF
usage:
  TBD ...
EOF
	exit 0
fi
# }}}

source ${0:A:h}/info.sh

# global vars {{{
THIS_DIR=${0:A:h}
RUN_CMD=$THIS_DIR/connect.sh

# coloring output {{{
blue()  { print -P "%F{blue}%B$1%b%f" }
green() { print -P "%F{green}%B$1%b%f" }
red()   { print -P "%F{red}%B$1%b%f" }
# }}}

send_file() {
	rsync -aPv \
		-e "ssh -i ${0:A:h}/key-pair.pem" \
		"$1" \
		$EC2_USERNAME@$2:~
}

IPS_PORTS=( )
for (( i=1; i<=${#IPS}; i++ )); do
	IPS_PORTS[$i]="${IPS[$i]}:$DEFAULT_PORT"
done

FILES_TO_SEND=( \
	"$THIS_DIR/.bash_profile" \
	"$THIS_DIR/.vimrc" \
	"$THIS_DIR/local-run.sh" \
	"$THIS_DIR/info.sh" \
	"$GOCHAI_DIR" \
	)
# }}}

# initial setup {{{
if [[ -n "$SETUP" ]]; then
	make -C $GOCHAI_DIR clean

	for IP in ${IPS[@]}; do
		ssh -i key-pair.pem $EC2_USERNAME@$IP sudo yum update -y
		if [[ $? -ne 0 ]]; then  echo "error while updating yum";  exit 1; fi

		ssh -i key-pair.pem $EC2_USERNAME@$IP sudo yum install -y golang zsh
		if [[ $? -ne 0 ]]; then  echo "error while installing packages";  exit 1; fi

		
		for file in ${FILES_TO_SEND[@]}; do
			send_file "$file" "$IP" \
				|| { echo "error while sending $file"; exit 1 }
		done

		ssh -i key-pair.pem $EC2_USERNAME@$IP make -C gochai clean all
		if [[ $? -ne 0 ]]; then  echo "error while building gochai";  exit 1; fi
	done

	exit 0
fi
# }}}

# kill all lingering processes
for ((i = 1; i <= ${#IPS}; i++)); do
	ssh -i key-pair.pem $EC2_USERNAME@${IPS[$i]} &>/dev/null << EOF
pkill -9 -f multipaxos
pkill -9 -f bin/master
pkill -9 -f bin/server
pkill -9 -f bin/client
EOF
done
if [[ -n "$KILL" ]]; then exit 0; fi

# start servers
for ((i = 1; i <= ${#IPS}; i++)); do
	$RUN_CMD -i $i -- \
		gochai/bin/multipaxos \
		$BATCH \
		-addr "$IPS[$i]:$DEFAULT_PORT" \
		-id $((i - 1)) \
		${IPS_PORTS[@]} &>/dev/null &
done

sleep 3

# start client
$RUN_CMD -i 1 -- \
	gochai/bin/client \
	$CONFLICT_PERC $REQUEST_COUNT $ROUND_COUNT $WRITE_PERC \
	${IPS_PORTS[@]}

# cleanup {{{
sleep 1
pkill -P $$ -9
sleep 1

green "DONE !"
# }}}
