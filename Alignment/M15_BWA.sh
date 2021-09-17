#!/bin/bash

SimPath="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/M15"

bwa mem -t 10 /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta \
	$SimPath/Sim15_reads_R1.fastq $SimPath/Sim15_reads_R2.fastq > $SimPath/Sim15_Ref.sam
samtools view -S -b $SimPath/Sim15_Ref.sam > $SimPath/Sim15_Ref.bam
samtools sort $SimPath/Sim15_Ref.bam -o $SimPath/Sim15_Ref_sorted.bam
samtools index $SimPath/Sim15_Ref_sorted.bam
