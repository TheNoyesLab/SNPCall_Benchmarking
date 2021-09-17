#!/bin/bash

###Arguments
while getopts f:r:b:d: flag
do
    case "${flag}" in
        d) data_path=${OPTARG};;
    esac
done

data_path=${data_path:-"M15"}

metaSNV.py /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/$data_path/Meta_Out \
	/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/$data_path/meta_sample_list.txt \
        /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta --threads 16 --min_pos_snvs 10

sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p' /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/$data_path/Meta_Out/snpCaller/called_SNPs.best_split_0 > /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/$data_path/Meta_Out/Meta_Out_Fix.csv


