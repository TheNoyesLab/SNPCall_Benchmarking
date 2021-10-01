#!/bin/bash

#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"




mkdir "$Bench/Benchmarking_Run"
mkdir "$Bench/Benchmarking_Run/SNP_Injector"

numreads=("0.5" "1" "5" "10" "15" "25") #just the number
datasets=("0.5" "1" "5" "10" "15" "25") #name of datasets/directories

for i in "${datasets[@]}"
do
	echo "$i"
	mkdir "$Bench/Benchmarking_Run/M$i"
	mkdir "$Bench/Benchmarking_Run/M$i/Alignment"
	mkdir "$Bench/Benchmarking_Run/M$i/Disco_Out"
	mkdir "$Bench/Benchmarking_Run/M$i/Freq_Out"
	mkdir "$Bench/Benchmarking_Run/M$i/GATK_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/FB_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/Samtools_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/VarDict_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/Ebwt_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/VarScan_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/MIDAS_Out"



	printf "$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R1.fastq\n$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R2.fastq" > $Bench/Benchmarking_Run/M$i/Fastqlist_Disco.txt 
	printf "$Bench/Benchmarking_Run/M$i/Alignment/Sim${i}_Ref_sorted.bam" > $Bench/Benchmarking_Run/M$i/meta_sample_list.txt
	printf "Ecoli	$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R1.fastq	$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R2.fastq" > $Bench/Benchmarking_Run/M$i/Fastqlist_Bact.txt
done
