#!/bin/bash


#####Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
#db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"



datasets=("0.5" "1" "5" "10" "15" "25" "50") #name of datasets/directories
subsets=("5" "15" "25" "35")

#####Start Alignment
echo "Start Alignment"

conda activate Align


for j in "${subsets[@]}"
do
        sub_db="$Bench/SNP_Injector/DB_noSNP_subset${j}.fasta"
	bwa index $sub_db
	samtools faidx $sub_db	

        #Dictionary for GATK
        gatk CreateSequenceDictionary -R $sub_db

        for i in "${datasets[@]}"
        do
                echo ""
                echo "Align: Subset $j, Dataset: $i"

                Set="$Bench/S$j/M$i"
                Align="$Bench/S$j/M$i/Alignment"


                #Do Alignment
                bwa mem -t 80 -R "@RG\tID:M${i}\tSM:2Strain\tPL:Illumina" $sub_db \
                        $Set/Sim${i}_reads_R1.fastq $Set/Sim${i}_reads_R2.fastq > $Align/Sim${i}_Ref.sam

                #Alignment post-processing
                samtools view -S -b $Align/Sim${i}_Ref.sam > $Align/Sim${i}_Ref.bam --threads 16
                samtools sort $Align/Sim${i}_Ref.bam -o $Align/Sim${i}_Ref_sorted.bam --threads 16
                samtools index $Align/Sim${i}_Ref_sorted.bam
                bedtools bamtobed -i $Align/Sim${i}_Ref_sorted.bam > $Align/Sim${i}_Ref_sorted.bed

                #Remove excess data
                rm $Align/Sim${i}_Ref.sam
                rm $Align/Sim${i}_Ref.bam
        done
done

