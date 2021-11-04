#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("0.5" "1" "5" "10" "15" "25" "50")
subsets=("5" "15" "25" "35") #number of reference sequences subsampled




#####
#####Start FreeBayes
#####
echo "Start FreeBayes"

#Start FB environment
conda activate FreeBayes

for j in "${subsets[@]}"
do
	sub_db="$Bench/SNP_Injector/DB_subset${j}.fasta"

	for i in "${datasets[@]}"
	do
		Align="$Bench/S$j/M$i/Alignment"

		/usr/bin/time -v -o $Bench/S$j/M$i/FB_Out/FB_Time.txt freebayes-parallel <(fasta_generate_regions.py ${sub_db}.fai 100000) 16 -f $sub_db -p 1 \
        		$Align/Sim${i}_Ref_sorted.bam > $Bench/S$j/M$i/FB_Out/FB_Out.vcf
		#freebayes -f $db -p 1 $Align/Sim${i}_Ref_sorted.bam > $Bench/S$j/M$i/FB_Out/FB_Out.vcf   #This is the non-parallel version
		/usr/bin/time -v -o $Bench/S$j/M$i/FB_Out/VCF_Time.txt vcftools --vcf $Bench/S$j/M$i/FB_Out/FB_Out.vcf --minQ 20 --recode --out $Bench/S$j/M$i/FB_Out/FB_Out_Filter

	done
done



#####
#####START GATK
#####

#Start GATK environment
conda activate GATK




for j in "${subsets[@]}"
do
	sub_db="$Bench/SNP_Injector/DB_subset${j}.fasta"

	for i in "${datasets[@]}"
	do
		Align="$Bench/S$j/M$i/Alignment"


		/usr/bin/time -v -o $Bench/S$j/M$i/GATK_Out/GATK_Time.txt gatk HaplotypeCaller \
        		-R $sub_db --native-pair-hmm-threads 16 \
        		-I $Align/Sim${i}_Ref_sorted.bam \
        		-O $Bench/S$j/M$i/GATK_Out/GATOut.vcf -ploidy 1 2>&1

	done
done


#####
#####START DISCOSNP
#####
echo "Start DiscoSNP"

#Start DiscoSNP environment
conda activate DiscoSNP

for j in "${subsets[@]}"
do
	sub_db="$Bench/SNP_Injector/DB_subset${j}.fasta"

	for i in "${datasets[@]}"
	do
		/usr/bin/time -v -o $Bench/S$j/M$i/Disco_Out/Disco_Time.txt run_discoSnp++.sh -r $Bench/S$j/M$i/Fastqlist_Disco.txt \
        		-G $sub_db\
        		--bwa_path ~/.conda/envs/DiscoSNP/bin/ -p Disco_Out -u 16
		mv $Bench/SNPCall_Benchmarking/Workflow/Disco_Out*  $Bench/S$j/M$i/Disco_Out/
	
	done
done



#####
#####START METASNV
#####
echo "Start MetaSNV"

#Start metasnv environment
conda activate metasnv

for j in "${subsets[@]}"
do
	for i in "${datasets[@]}"
	do
		/usr/bin/time -v -o $Bench/S$j/M$i/Meta_Out/Meta_Time.txt metaSNV.py $Bench/S$j/M$i/Meta_Out \
        		$Bench/S$j/M$i/meta_sample_list.txt \
        		$db --threads 64


		cat $Bench/S$j/M$i/Meta_Out/snpCaller/called_SNPs.best_split_* | sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p' > $Bench/S$j/M$i/Meta_Out/Meta_Out_Fix.csv

	done
done




#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
#conda activate InSilicoSeq

#for k in "${datasets[@]}"
#do

#python ../Benchmarking/Compare_vcf.py -i $Bench/M${k}/FB_Out/FB_Out_Filter.recode.vcf $Bench/M${k}/Disco_Out/Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent.vcf $Bench/M${k}/GATK_Out/GATOut.vcf -G $Bench/SNP_Injector/Full2SNPLog.csv

###Do non-standard format benchmarking
#python ../Benchmarking/Compare_csv.py -m $Bench/M${k}/Meta_Out/Meta_Out_Fix.csv -G $Bench/SNP_Injector/Full2SNPLog.csv 

#done
