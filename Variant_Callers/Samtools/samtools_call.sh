#!/bin/bash


samtools mpileup -uD \
	/home/noyes046/shared/databases/megares_v2.0/megares_full_database_v2.00.fasta /home/noyes046/shared/projects/SNP_Call_Benchmarking/Omar_VC_Popular/TestAlign_sorted.bam | bcftools call -mv> OmarSamtools.vcf
	#| bcftools view -bvcg - > variants.raw.bcf
