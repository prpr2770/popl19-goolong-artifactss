#!/bin/zsh

zparseopts -D -E -- \
	n:=NUMBER_OF_ITER

if [[ $? -ne 0 ]]; then
	echo "argument parsing failed !" >&2
	exit 1
fi

if [[ $# -eq 0 ]]; then
	echo "usage: $0 <script to run> [script args]" >&2
	echo "averages the times in 'Round took ...'"  >&2
	exit 1
fi

SCRIPT=${1:A}
shift

if [[ -z "$NUMBER_OF_ITER" ]]; then
	N=10
else
	N=${NUMBER_OF_ITER[2]}
fi

awkscript='
/^Round took/ {
  val  = $3;
  sum += val;
  n   += 1;
  printf("%-3d %g\n", n, val);
  fflush();
}
END {
  if (n > 0) {
    printf("average : %g\n", sum / n);
  } else {
    printf("awk: input empty\n");
  }
  fflush();
}'

{
	for (( i=1; i<=$N; i++ )); do 
		$SCRIPT $@
	done 
} | gawk -F' ' "$awkscript"
# }

