#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("1")


###Start FreeBayes
echo "Start FreeBayes"

#Start FB environment
conda activate FreeBayes

for i in "${datasets[@]}"
do
Align="$Bench/Benchmarking_Run/M$i/Alignment"

/usr/bin/time -v -o $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Time.txt freebayes-parallel <(fasta_generate_regions.py ${db}.fai 100000) 16 -f $db -p 1 \
        $Align/Sim${i}_Ref_sorted.bam > $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf
#freebayes -f $db -p 1 $Align/Sim${i}_Ref_sorted.bam > $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf   #This is the non-parallel version
/usr/bin/time -v -o $Bench/Benchmarking_Run/M${i}/FB_Out/VCF_Time.txt vcftools --vcf $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf --minQ 20 --recode --out $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out_Filter
done


#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq

for k in "${datasets[@]}"
do

python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv
#python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M${k}/Samtools_Out/Sam_Out.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv

###Do non-standard format benchmarking
#python ../Benchmarking/Compare_csv.py -m $Bench/Benchmarking_Run/M${k}/Meta_Out/Meta_Out_Fix.csv -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv 

done
