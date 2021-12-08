# POPL 2019 - Artifact Evaluation

## Website

https://goto.ucsd.edu/~rkici/popl19_artifact_evaluation/

## Setting Up

1. Make sure [Go](https://golang.org/dl/), Python, [Stack](https://docs.haskellstack.org/en/stable/README/), [Sicstus](https://sicstus.sics.se/) and [Z3](https://github.com/Z3Prover/z3) are installed in your system.
2. Clone this repository with `--recursive`.
3. Run `make` in the `gochai` directory.
4. Run `stack install` in the `Brisk-VCGen` directory.

## IceT vs Dafny Comparison Table

Run the `dafny-comparison` script (which simply runs `icet_vs_dafny/print_table.py`).

## Verification of Benchmarks Written in Goolang

Run the `verify-benchmarks` script (which simply runs `gochai/verify-benchmark`).

