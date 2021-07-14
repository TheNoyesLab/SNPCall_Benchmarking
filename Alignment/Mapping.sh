#!/bin/bash

#minimap2 -ax sr /home/noyes046/shared/databases/Jesse_database/Jesse_db_only_complete.fasta 100k_test_R1.fastq 100k_test_R2.fastq > TestAlignment.sam  #Create the alignment to megares

#Build a bowtie index
bowtie2-build -f /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta \
	/home/noyes046/shared/databases/Jesse_database/bowtie_db/Jesse_database_bowtie 
bowtie2 --rg-id 100k_test --rg SM:AME1 --rg PL:Illumina \
	-p 10 -x /home/noyes046/shared/databases/Jesse_database/bowtie_db/Jesse_database_bowtie \
	-1 100k_test_R1.fastq -2 100k_test_R2.fastq -S TestAlignment.sam 


samtools view -S -b TestAlignment.sam > TestAlignment.bam #Convert sam to bam
samtools sort TestAlignment.bam -o TestAlign_sorted.bam #Sort bam file
samtools view -h -o TestAlign_sorted.sam TestAlign_sorted.bam #make a sam again because

#create bed file
bedtools bamtobed -i TestAlign_sorted.bam > TestAlign_sorted.bed

#create bai file
samtools index TestAlign_sorted.bam
