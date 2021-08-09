#!/bin/bash

#conda activate GATK
bowtie2-build -f /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta GATK_Stuff/Multi_bowtie

bowtie2 --rg-id 100k_test --rg SM:Multi --rg PL:Illumina \
        -p 10 -x GATK_Stuff/Multi_bowtie -1 Simmy_reads_R1.fastq -2 Simmy_reads_R2.fastq -S Bow_Multi_Out.sam

samtools view -S -b Bow_Multi_Out.sam > Bow_Multi_Out.bam #Convert sam to bam
samtools sort Bow_Multi_Out.bam -o Bow_Multi_sorted.bam #Sort bam file
bedtools bamtobed -i Bow_Multi_sorted.bam > Bow_Multi_sorted.bed #Make a bed file
samtools index Bow_Multi_sorted.bam
