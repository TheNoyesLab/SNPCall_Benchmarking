#!/bin/bash

run_discoSnp++.sh -r Fastqlist.txt \
        -G  SNPReference.fasta\
        --bwa_path /panfs/roc/msisoft/bwa/0.7.17_gcc-7.2.0_haswell -p Disco_Out
