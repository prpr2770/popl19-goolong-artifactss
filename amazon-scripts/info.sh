THIS_DIR="${0:A:h}"

export EC2_USERNAME="ec2-user"

export IPS=( \
		ec2-18-216-34-111.us-east-2.compute.amazonaws.com \
		ec2-18-221-122-62.us-east-2.compute.amazonaws.com \
		ec2-18-217-128-115.us-east-2.compute.amazonaws.com \
	   )

export DEFAULT_PORT="7070"

export MASTER_IP=${IPS[1]}
export CLIENT_IP=${IPS[1]}

export GOCHAI_DIR="${THIS_DIR}/../gochai"

export EPAXOS_DIR="${THIS_DIR}/../epaxos"

#SCALA

export SCALA_VERSION="2.12.6"

export PSYNC_DIR="${THIS_DIR}/../psync"
export PSYNC_CONF="$THIS_DIR/conf.xml"
