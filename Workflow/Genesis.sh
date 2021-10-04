#!/bin/bash


#####Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"



mkdir "$Bench/Benchmarking_Run"
mkdir "$Bench/Benchmarking_Run/SNP_Injector"

numreads=("0.5" "1" "5" "10" "15" "25") #just the number
datasets=("0.5" "1" "5" "10" "15" "25") #name of datasets/directories

for i in "${datasets[@]}"
do
	echo "$i"
	mkdir "$Bench/Benchmarking_Run/M$i"
	mkdir "$Bench/Benchmarking_Run/M$i/Alignment"
	mkdir "$Bench/Benchmarking_Run/M$i/Disco_Out"
	mkdir "$Bench/Benchmarking_Run/M$i/Freq_Out"
	mkdir "$Bench/Benchmarking_Run/M$i/GATK_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/FB_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/Samtools_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/VarDict_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/Ebwt_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/VarScan_Out"
        mkdir "$Bench/Benchmarking_Run/M$i/MIDAS_Out"



	printf "$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R1.fastq\n$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R2.fastq" > $Bench/Benchmarking_Run/M$i/Fastqlist_Disco.txt 
	printf "$Bench/Benchmarking_Run/M$i/Alignment/Sim${i}_Ref_sorted.bam" > $Bench/Benchmarking_Run/M$i/meta_sample_list.txt
	printf "Ecoli	$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R1.fastq	$Bench/Benchmarking_Run/M$i/Sim${i}_reads_R2.fastq" > $Bench/Benchmarking_Run/M$i/Fastqlist_Bact.txt
done





conda activate InSilicoSeq

###Start SNP_Injector
echo "Start SNP_Injector"
python SNP_Injector_Fasta.py -s 2 -r $db


###Start InSilicoSeq
echo "Start InSilicoSeq"
subsets=("0.5" "1")
for j in "${subsets[@]}"
do
	iss generate --genomes $Bench/Benchmarking_Run/SNP_Injector/Jesse_full_db_2strain_SNP.fasta -n ${j}m --cpus 16 --mode perfect --output $Bench/Benchmarking_Run/M${j}/Sim${j}_reads

done



#####Start Alignment
echo "Start Alignment"

conda activate Align

subset2=("0.5" "1")
for k in "${subset2[@]}"
do
Set="$Bench/Benchmarking_Run/M$k"
Align="$Bench/Benchmarking_Run/M$k/Alignment"

bwa mem -t 10 -R "@RG\tID:M${k}\tSM:2Strain\tPL:Illumina" $db \
        $Set/Sim${k}_reads_R1.fastq $Set/Sim${k}_reads_R2.fastq > $Align/Sim${k}_Ref.sam
samtools view -S -b $Align/Sim${k}_Ref.sam > $Align/Sim${k}_Ref.bam
samtools sort $Align/Sim${k}_Ref.bam -o $Align/Sim${k}_Ref_sorted.bam
samtools index $Align/Sim${k}_Ref_sorted.bam
bedtools bamtobem -i $Align/Sim${k}_Ref_sorted.bam > $Align/Sim${k}_Ref_sorted.bed

done
