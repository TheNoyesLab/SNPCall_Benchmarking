#!/bin/bash



metaSNV.py /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/M5/Meta_Out \
	/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/M5/meta_sample_list.txt \
        /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/Ecoli_Ref.fasta --threads 16 --min_pos_snvs 10

sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p' /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/M5/Meta_Out/snpCaller/called_SNPs.best_split_0 > /home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/M5/Meta_Out/Meta_Out_Fix.csv


