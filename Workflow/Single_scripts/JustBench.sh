#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
#db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh

#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq


datasets=("0.5" "1" "5" "10" "15" "25" "50") #name of datasets/directories
subsets=("5" "15" "25" "35") #number of reference sequences subsampled

for j in "${subsets[@]}"
do

	for i in "${datasets[@]}"
	do
		
		###Do benchmarking on VCF files
		python ../Benchmarking/Compare_vcf.py -i $Bench/S$j/M$i/FB_Out/FB_Out_Filter.recode.vcf $Bench/S$j/M$i/Disco_Out/Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent.vcf $Bench/S$j/M$i/GATK_Out/GATOut.vcf -G $Bench/SNP_Injector/SNPLog_subset${j}.csv

		###Do non-standard format benchmarking
		python ../Benchmarking/Compare_csv.py -m $Bench/S$j/M$i/Meta_Out/Meta_Out_Fix.csv -G $Bench/SNP_Injector/SNPLog_subset${j}.csv
		
		###Extract the Time & Memory Benchmarks		
		python ../Benchmarking/Time_Benchmarks.py -t $Bench/S$j/M$i/FB_Out/FB_Time.txt $Bench/S$j/M$i/GATK_Out/GATK_Time.txt $Bench/S$j/M$i/Disco_Out/Disco_Time.txt $Bench/S$j/M$i/Meta_Out/Meta_Time.txt
	done
done


#Merge the Benchmarking Datasets together!!!
echo "Final step: Merging Benchmarks!!!"
python ../Benchmarking/Merge_Bench.py


