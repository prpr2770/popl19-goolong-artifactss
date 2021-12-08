# Amazon EC2 Scripts

## Notes

1. Use the `multi-run.sh` script to run the corresponding tests.

```bash
./multi-run.sh -n <# iterations> <script name> <script args>
```

2. Update `info.sh` when instance ips change (i.e. when instances are stopped & restarted).

3. Enable TCP ports in the "security groups" part of the EC2 console

## gochai 

Script to use is `test_gochai.sh`, the arguments are the following:

```
script arguments:
  --setup      copies the files & folders, builds the project, etc.
  --kill       kills the clients & servers running in the instances

multi paxos arguments: 
  -b           batch mode
  -c <PERC>    conflict percentage
  -q <N>       request count
  -r <N>       round count
  -w <PERC>    write percentage
```

## EPaxos

Script to use is `test_epaxos.sh`, the arguments are the following:

```
script arguments:
  --setup             copies the files & folders, builds the project, etc.
  --kill              kills the clients & servers running in the instances

epaxos arguments: 
  --no-egalitarian    disable egalitarian paxos mode
  -c <PERC>           conflict percentage
  -q <N>              request count
  -r <N>              round count
  -w <PERC>           write percentage
```

## PSync

Script to use is `psync_parallel.sh`.

### Building the project

1. Run `test_psync.sh --java <N>`
2. Run `test_psync.sh --scala <N>`
3. Run `test_psync.sh --send-files <N>`
4. Log in using `connect.sh -i <N>` and run the following **manually** (otherwise it hangs):
```bash
cd psync
sbt clean
sbt compile
sbt test:compile
./test_scripts/generateClassPath.sh
```
