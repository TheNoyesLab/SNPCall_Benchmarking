#!/bin/bash

lofreq call-parallel --pp-threads 8 \
	-f /home/noyes046/shared/databases/megares_v2.0/megares_full_database_v2.00.fasta \
	-o FreqOut.vcf /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam
