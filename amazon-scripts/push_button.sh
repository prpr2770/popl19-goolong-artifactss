#!/bin/zsh

THIS_DIR=${0:A:h}
LOGS_DIR=$THIS_DIR/logs
DATE=$(date +'%Y%m%d_%H%M')

$THIS_DIR/multi-params.sh $THIS_DIR/test_gochai.sh -b | tee "${LOGS_DIR}/${DATE}_gochai_batched.txt"

$THIS_DIR/multi-params.sh $THIS_DIR/test_epaxos.sh    | tee "${LOGS_DIR}/${DATE}_epaxos_batched.txt"

# $THIS_DIR/multi-params.sh $THIS_DIR/test_gochai.sh    | tee "${LOGS_DIR}/${DATE}_gochai_unbatched.txt"

