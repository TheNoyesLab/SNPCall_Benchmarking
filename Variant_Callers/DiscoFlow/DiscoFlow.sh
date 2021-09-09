#!/bin/bash

###Arguments
while getopts f:r: flag
do
    case "${flag}" in
        f) fq_list=${OPTARG};;
	r) reference=${OPTARG};;
    esac
done

#Start conda
. /panfs/roc/msisoft/anaconda/anaconda3_2020.07/etc/profile.d/conda.sh
conda activate DiscoSNP

#Set up a path
SimPath="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets"
#Set a default reference
reference=${reference:-"$SimPath/Ecoli_Ref.fasta"}
fq_list=${fq_list:-"$SimPath/M5/Fastqlist.txt"}


run_discoSnp++.sh -r $fq_list \
        -G $reference\
        --bwa_path ~/.conda/envs/DiscoSNP/bin/ -p Disco_Out
mv Disco_Out* $SimPath/M5/Disco_Out/
