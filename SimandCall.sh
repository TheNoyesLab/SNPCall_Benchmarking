#!/bin/bash

###Activate conda.sh
source /panfs/roc/msisoft/anaconda/anaconda3-2018.12/etc/profile.d/conda.sh


##Activate InSilicoSeq environment
conda activate InSilicoSeq

##Run InSilicoSeq
iss generate --ncbi bacteria viruses archaea -U 3 1 1 -n 0.5M --coverage zero_inflated_lognormal --model novaseq \
	--output /home/noyes046/shared/projects/SNP_Call_Benchmarking/InSilicoSeq/SynthData/Mixed_Nova_short/ncbi_8008_ --cpu 10 --seed 8008



##Activate DiscoSNP++ environment
echo 'Move to Disco'
conda activate DiscoSNP

#Creating list of synthetic reads for DiscoSNP
ls -1 /home/noyes046/shared/projects/SNP_Call_Benchmarking/InSilicoSeq/SynthData/Mixed_Nova_short/*.fastq > Fastqlist.txt
grep '^' Fastqlist.txt
echo 'Made the list. Running DiscoSnp.'

##Run DiscoSNP++
run_discoSnp++.sh -r /home/noyes046/shared/projects/SNP_Call_Benchmarking/Fastqlist.txt -T \
	-G /home/noyes046/shared/databases/megares_v2.0/megares_full_database_v2.00.fasta \
	--bwa_path /panfs/roc/msisoft/bwa/0.7.17_gcc-7.2.0_haswell -p DiscoSNP_output/Mixed_Nova_short


