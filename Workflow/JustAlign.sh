#!/bin/bash


#####Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"



datasets=("0.5" "1") #name of datasets/directories
subsets=("5" "15" "25" "35")

#####Start Alignment
echo "Start Alignment"

conda activate Align

for j in "${subsets[@]}"
do
	for i in "${datasets[@]}"
	do
		Set="$Bench/Benchmarking_Run/S$j/M$i"
		Align="$Bench/Benchmarking_Run/S$j/M$i/Alignment"
	
		#Do Alignment
		bwa mem -t 32 -R "@RG\tID:M${i}\tSM:2Strain\tPL:Illumina" $db \
        		$Set/Sim${i}_reads_R1.fastq $Set/Sim${i}_reads_R2.fastq > $Align/Sim${i}_Ref.sam
	
		#Alignment post-processing
		samtools view -S -b $Align/Sim${i}_Ref.sam > $Align/Sim${i}_Ref.bam
		samtools sort $Align/Sim${i}_Ref.bam -o $Align/Sim${i}_Ref_sorted.bam
		samtools index $Align/Sim${i}_Ref_sorted.bam
		bedtools bamtobed -i $Align/Sim${i}_Ref_sorted.bam > $Align/Sim${i}_Ref_sorted.bed
	
		#Remove excess data
		rm $Align/Sim${i}_Ref.sam
		rm $Align/Sim${i}_Ref.bam
	done
done
