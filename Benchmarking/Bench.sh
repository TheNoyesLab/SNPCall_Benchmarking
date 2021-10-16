#!/bin/bash

###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh

conda activate InSilicoSeq

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"

###Run python script with 3 vcf files and known SNPs in 2 E.coli strains
#python Compare_vcf.py -i ../../Disco_Out.vcf ../../FreqDoubleOut.vcf ../../Strelka_Double.vcf -G ../../DoubleSNPLog.csv

python Compare_vcf.py -i $Bench/Benchmarking_Run/M25/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M25/GATK_Out/GATOut.vcf $Bench/Benchmarking_Run/M25/Disco_Out/Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv
