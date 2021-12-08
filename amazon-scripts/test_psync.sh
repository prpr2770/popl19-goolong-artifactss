#!/bin/zsh
# vim: set foldmethod=marker:

# argument parsing {{{
THIS_DIR=${0:A:h}
source $THIS_DIR/info.sh

zparseopts -D -E -- \
	-java=INSTALL_JAVA -scala=INSTALL_SCALA -send-files=SEND_FILES -compile=COMPILE -test=TEST_PSYNC

if [[ $# -ne 1 ]]; then
	echo "usage: ${0:h} <instance #>" >&2
	exit 1
fi

INSTANCE=$1
shift

if [[ $INSTANCE -lt 1 || $INSTANCE -gt ${#IPS} ]]; then
	echo "index $INSTANCE out of bounds" >&2
	exit 1
fi
# }}}

ip=${IPS[$INSTANCE]}

# install java {{{
JAVA_BASE_VERSION="8"
JAVA_SUB_VERSION="171"
JAVA_VERSION="${JAVA_BASE_VERSION}u${JAVA_SUB_VERSION}"
JDK_FILENAME="$THIS_DIR/jdk-${JAVA_VERSION}-linux-x64.rpm" 

if [[ -n "$INSTALL_JAVA" ]]; then

	if [[ ! -f "$JDK_FILENAME" ]]; then
		echo "$JDK_FILENAME does not exist!" >&2
		exit 1
	fi

	ssh -i key-pair.pem $EC2_USERNAME@$ip command -v java &>/dev/null

	if [[ $? -ne 0 ]]; then
		rsync -aPv \
			-e "ssh -i $THIS_DIR/key-pair.pem" \
			"$JDK_FILENAME" \
			$EC2_USERNAME@$ip:~

		ssh -i key-pair.pem $EC2_USERNAME@$ip << EOF
sudo rpm -i jdk-${JAVA_VERSION}-linux-x64.rpm
EOF
	else
		echo "skipping java installation ..."
	fi
fi
# }}}

# install scala {{{
if [[ -n "$INSTALL_SCALA" ]]; then
	ssh -i key-pair.pem $EC2_USERNAME@$ip command -v sbt &>/dev/null

	if [[ $? -ne 0 ]]; then
		ssh -i key-pair.pem $EC2_USERNAME@$ip << EOF
wget http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz
tar -xzvf scala-${SCALA_VERSION}.tgz
rm -rf scala-${SCALA_VERSION}.tgz

curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt -y
EOF
	else
		echo "skipping sbt installation ..."
	fi
fi
# }}}

# copy psync {{{
if [[ -n "$SEND_FILES" ]]; then
	rsync -aPv \
		-e "ssh -i $THIS_DIR/key-pair.pem" \
		"$PSYNC_DIR" \
		$EC2_USERNAME@$ip:~
fi
# }}}

# build psync {{{
if [[ -n "$COMPILE" ]]; then
	ssh -i key-pair.pem $EC2_USERNAME@$ip << EOF
cd psync
sbt clean
sbt compile
sbt test:compile
./test_scripts/generateClassPath.sh
EOF
fi
# }}}

# test psync {{{
if [[ -n "$TEST_PSYNC" ]]; then
	$THIS_DIR/generate_conf.sh

	rsync -aPv \
		-e "ssh -i $THIS_DIR/key-pair.pem" \
		"$PSYNC_CONF" \
		$EC2_USERNAME@$ip:psync/ &>/dev/null

	rsync -aPv \
		-e "ssh -i $THIS_DIR/key-pair.pem" \
		"$THIS_DIR/local-psync.sh" \
		$EC2_USERNAME@$ip:psync/test_scripts/ &>/dev/null

	I_MIN_1=$((INSTANCE - 1))

	ssh -i key-pair.pem $EC2_USERNAME@$ip << EOF
cd psync
./test_scripts/local-psync.sh ${I_MIN_1}
EOF
fi
# }}}

echo "DONE !"
