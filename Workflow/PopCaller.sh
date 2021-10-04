#!/bin/bash



###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh



###Start FreeBayes
echo "Start FreeBayes"

#Start FB environment
conda activate FreeBayes

subset2=("0.5" "1")
for i in "${subset2[@]}"
do
Align="$Bench/Benchmarking_Run/M$i/Alignment"

freebayes-parallel <(fasta_generate_regions.py ${db}.fai 100000) 16 -f $db -p 1 \
	$Align/Sim${i}_Ref_sorted.bam > $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf
#freebayes -f $db -p 1 $Align/Sim${i}_Ref_sorted.bam > $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf   #This is the non-parallel version

done 


#Start Samtools environment
conda activate samtools

echo "Start samtools"

for j in "${subset2[@]}"
do
Align="$Bench/Benchmarking_Run/M$j/Alignment"
bcftools mpileup -D --regions-file $Align/Sim${j}_Ref_sorted.bed --fasta-ref $db $Align/Sim${j}_Ref_sorted.bam | bcftools call --ploidy 1 -mv > $Bench/Benchmarking_Run/M$j/Samtools_Out/Sam_Out.vcf

done


#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq

for k in "${subset2[@]}"
do
python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M${k}/Samtools_Out/Sam_Out.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv


done

