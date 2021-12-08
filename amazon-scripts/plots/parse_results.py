#!/usr/bin/env python2

import sys
import argparse
import re

parser = argparse.ArgumentParser()
parser.add_argument('-q', dest='q', type=int)
parser.add_argument('-w', dest='w', type=int)
parser.add_argument('-b', dest='b', action='store_true')
parser.add_argument('--no-egalitarian', dest='no_egalitarian', action='store_true')

name = None
q    = None
w    = None

throughput_sum = None
throughput_cnt = None

def escape_ansi(line):
    ansi_escape = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -/]*[@-~]')
    return ansi_escape.sub('', line)

def parse_results(filename):
    results = []

    with open(filename, 'r') as f:
        throughputs = None

        for line in f:
            cols = map(escape_ansi, line.split())

            if (cols[0] == 'running:'):
                name = cols[1]
                args = parser.parse_args(cols[2:])

                if throughputs is not None:
                    results.append({
                        "q"      : q,
                        "w"      : w,
                        "values" : throughputs,
                        })

                q = args.q
                w = args.w
                throughputs = []

                continue
            elif(cols[0] == 'average'):
                continue

            t = float(cols[1]) * 1000
            throughput = q / t
            throughputs.append(throughput)

        results.append({
            "q"      : q,
            "w"      : w,
            "values" : throughputs,
            })

    return results

if __name__ == '__main__':
    if (len(sys.argv) != 2):
        print "run with a log file"
        sys.exit(1)
    r = parse_results(sys.argv[1])
    for x in r:
        print x
