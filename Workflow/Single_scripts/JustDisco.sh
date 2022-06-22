#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("5")
subsets=("5") #number of reference sequences subsampled




#####
#####START DISCOSNP
#####
echo "Start DiscoSNP"

#Start DiscoSNP environment
conda activate DiscoSNP

Work="/home/noyes046/shared/projects/SNP_Call_Benchmarking/SNPCall_Benchmarking" #Workflow path to move files from

for j in "${subsets[@]}"
do
        sub_db="$Bench/SNP_Injector/DB_noSNP_subset${j}.fasta"

        for i in "${datasets[@]}"
        do
                /usr/bin/time -v -o $Bench/S$j/M$i/Disco_Out/Disco_Time.txt run_discoSnp++.sh -r $Bench/S$j/M$i/Fastqlist_Disco.txt \
                        -G $sub_db\
                        --bwa_path ~/.conda/envs/DiscoSNP/bin/ -p Disco_Out -u 32
                mv $Work/Workflow/Disco_Out*  $Bench/S$j/M$i/Disco_Out/

        done
done


