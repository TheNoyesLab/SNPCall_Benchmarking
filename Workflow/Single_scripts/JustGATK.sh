#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("1")



#####
#####START GATK
#####

#Start GATK environment
conda activate GATK


#gatk CreateSequenceDictionary -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta

for i in "${datasets[@]}"
do
Align="$Bench/Benchmarking_Run/M$i/Alignment"
/usr/bin/time -v -o $Bench/Benchmarking_Run/M${i}/GATK_Out/GATK_Time.txt gatk HaplotypeCaller \
        -R $db --native-pair-hmm-threads 16 \
        -I $Align/Sim${i}_Ref_sorted.bam \
        -O $Bench/Benchmarking_Run/M${i}/GATK_Out/GATOut.vcf -ploidy 1 2>&1 
#echo "GATK $timing" > $Bench/Benchmarking_Run/M${i}/GATK_Out/GATK_Time.txt
#cat $Bench/Benchmarking_Run/M${i}/GATK_Out/GATK_Time.txt

done




