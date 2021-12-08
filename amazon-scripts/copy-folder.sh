#!/bin/zsh

if [[ $# -ne 1 ]]; then
	echo "sends file/folder to the amazon ec2 instance" >&2
	echo "usage: ${0:t} <folder/file name>"             >&2
	exit 1
fi

source ${0:A:h}/info.sh

FILENAME="${1:A}"

for IP in ${IPS[@]}; do
	rsync -aPv \
		-e "ssh -i ${0:A:h}/key-pair.pem" \
		$FILENAME \
		$EC2_USERNAME@$IP:~
done



