#!/bin/bash
#freebayes variant calling

freebayes -f /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta -p 1\
	 /home/noyes046/shared/projects/SNP_Call_Benchmarking/Omar_VC_Popular/TestAlign_sorted.bam > freebayes_OJL.vcf
