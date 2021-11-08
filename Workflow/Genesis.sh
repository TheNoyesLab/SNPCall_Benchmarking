#!/bin/bash


#####Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
#db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


mkdir "$Bench"
mkdir "$Bench/SNP_Injector"


datasets=("0.5" "1" "5" "10" "15" "25" "50") #name of datasets/directories
subsets=("5" "15" "25" "35") #number of reference sequences subsampled

for j in "${subsets[@]}"
do
        echo "$j"
        mkdir "$Bench/S$j" #Make subset directories

        for i in "${datasets[@]}"
        do
                echo "$i"
                mkdir "$Bench/S$j/M$i"  #Make dataset directories
                mkdir "$Bench/S$j/M$i/Alignment"
                mkdir "$Bench/S$j/M$i/Disco_Out"
                mkdir "$Bench/S$j/M$i/Freq_Out"
                mkdir "$Bench/S$j/M$i/GATK_Out"
                mkdir "$Bench/S$j/M$i/FB_Out"
                mkdir "$Bench/S$j/M$i/Samtools_Out"
                mkdir "$Bench/S$j/M$i/VarDict_Out"
                mkdir "$Bench/S$j/M$i/Ebwt_Out"
                mkdir "$Bench/S$j/M$i/VarScan_Out"
                mkdir "$Bench/S$j/M$i/MIDAS_Out"


                printf "$Bench/S$j/M$i/Sim${i}_reads_R1.fastq\n$Bench/S$j/M$i/Sim${i}_reads_R2.fastq" > $Bench/S$j/M$i/Fastqlist_Disco.txt
                printf "$Bench/S$j/M$i/Alignment/Sim${i}_Ref_sorted.bam" > $Bench/S$j/M$i/meta_sample_list.txt
                printf "Ecoli   $Bench/S$j/M$i/Sim${i}_reads_R1.fastq   $Bench/S$j/M$i/Sim${i}_reads_R2.fastq" > $Bench/S$j/M$i/Fastqlist_Bact.txt
        done
done


conda activate InSilicoSeq

###Start SNP_Injector
echo "Start SNP_Injector"
python SNP_Injector_Fasta.py -s 2 -r $db


###Start InSilicoSeq
echo "Start InSilicoSeq"

for j in "${subsets[@]}"
do
        for i in "${datasets[@]}"
        do
		echo ""
		echo "Synth: Subset $j, Datset: $i"
                iss generate --genomes "$Bench/SNP_Injector/DB_subset${j}.fasta" -n ${i}m --cpus 64 --model miseq --output $Bench/S${j}/M${i}/Sim${i}_reads
        done
done



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
                bwa mem -t 64 -R "@RG\tID:M${i}\tSM:2Strain\tPL:Illumina" $sub_db \
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


