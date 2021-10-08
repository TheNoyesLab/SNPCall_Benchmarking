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

subset2=("15")
for i in "${subset2[@]}"
do
Align="$Bench/Benchmarking_Run/M$i/Alignment"

freebayes-parallel <(fasta_generate_regions.py ${db}.fai 100000) 16 -f $db -p 1 \
        $Align/Sim${i}_Ref_sorted.bam > $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf
#freebayes -f $db -p 1 $Align/Sim${i}_Ref_sorted.bam > $Bench/Benchmarking_Run/M${i}/FB_Out/FB_Out.vcf   #This is the non-parallel version

done

#####
#####START DISCOSNP
#####

#Start GATK environment
conda activate GATK


#gatk CreateSequenceDictionary -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta

subset2=("15")
for i in "${subset2[@]}"
do
gatk HaplotypeCaller\
        -R $db \
        -I $Align/Sim${i}_Ref_sorted.bam \
        -O $Bench/Benchmarking_Run/M${i}/GATK_Out/GATOut.vcf -ploidy 1
done


#####
#####START DISCOSNP
#####
echo "Start DiscoSNP"

#Start DiscoSNP environment
conda activate DiscoSNP

subset2=("15")
for i in "${subset2[@]}"
do
run_discoSnp++.sh -r $Bench/Benchmarking_Run/M${i}/Fastqlist_Disco.txt \
        -G $db\
        --bwa_path ~/.conda/envs/DiscoSNP/bin/ -p Disco_Out -u 16
mv $Bench/SNPCall_Benchmarking/Workflow/Disco_Out*  $Bench/Benchmarking_Run/M${i}/Disco_Out/

done



#####
#####START METASNV
#####
echo "Start MetaSNV"

#Start metasnv environment
conda activate metasnv


subset2=("15")
for i in "${subset2[@]}"
do
metaSNV.py $Bench/Benchmarking_Run/M${i}/Meta_Out \
        $Bench/Benchmarking_Run/M${i}/meta_sample_list.txt \
        $db --threads 16 --min_pos_snvs 3


cat $Bench/Benchmarking_Run/M${i}/Meta_Out/snpCaller/called_SNPs.best_split_* | sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p' > $Bench/Benchmarking_Run/M${i}/Meta_Out/Meta_Out_Fix.csv

done




#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq

for k in "${subset2[@]}"
do

python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M${k}/Disco_Out/Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent.vcf $Bench/Benchmarking_Run/M${k}/GATK_Out/GATOut.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv
#python ../Benchmarking/Compare_vcf.py -i $Bench/Benchmarking_Run/M${k}/FB_Out/FB_Out.vcf $Bench/Benchmarking_Run/M${k}/Samtools_Out/Sam_Out.vcf -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv

###Do non-standard format benchmarking
python ../Benchmarking/Compare_csv.py -m $Bench/Benchmarking_Run/M${k}/Meta_Out/Meta_Out_Fix.csv -G $Bench/Benchmarking_Run/SNP_Injector/Full2SNPLog.csv 

done
