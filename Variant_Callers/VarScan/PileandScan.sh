#!/bin/bash

samtools mpileup -f /home/noyes046/shared/databases/megares_v2.0/megares_full_database_v2.00.fasta /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam > /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign.mpileup

varscan mpileup2snp /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign.mpileup > TestVarScan.vcf
