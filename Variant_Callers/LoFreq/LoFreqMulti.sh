#!/bin/bash

lofreq call-parallel --pp-threads 8 \
        -f  /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta\
        -o FreqMultiOut.vcf Bow_Multi_sorted.bam
