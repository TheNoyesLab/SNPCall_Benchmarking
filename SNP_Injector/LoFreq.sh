#!/bin/bash

lofreq call-parallel --pp-threads 8 \
        -f  Ecoli_Ref.fasta\
        -o FreqOut.vcf Bow_sorted.bam
