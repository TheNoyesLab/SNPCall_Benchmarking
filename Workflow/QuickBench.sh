#!/bin/bash

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"

###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh

#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq

subset2=("15")
for k in "${subset2[@]}"
do

python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M${k}/Disco_Out/Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent.vcf $Bench/Benchmarking_Run/M${k}/GATK_Out/GATOut.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv
#python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M${k}/Samtools_Out/Sam_Out.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv


done

