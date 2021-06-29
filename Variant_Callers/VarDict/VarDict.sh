#!/bin/bash


vardict -G /home/noyes046/shared/databases/megares_v2.0/megares_full_database_v2.00.fasta \
	-b /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam \
	-c 1 -S 2 -E 3 -g 4 /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bed
