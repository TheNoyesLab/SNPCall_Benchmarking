#!/bin/bash

###Arguments
while getopts f:r:b:d: flag
do
    case "${flag}" in
	d) data_path=${OPTARG};;
        f) fq_list=${OPTARG};;
        r) reference=${OPTARG};;
	b) bam_file=${OPTARG};;
    esac
done


###Set up a path
SimPath="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets"
###Set up default values 
data_path=${data_path:-"M5"}
reference=${reference:-"$SimPath/Ecoli_Ref.fasta"}
fq_list=${fq_list:-"$SimPath/$data_path/Fastqlist.txt"}
bam_file=${bam_file:-"$SimPath/$data_path/Ecoli_Ref_sorted.bam"}

###Start conda
. /panfs/roc/msisoft/anaconda/anaconda3_2020.07/etc/profile.d/conda.sh



#####
#####START DISCOSNP
#####
echo "Start DiscoSNP"

#Start DiscoSNP environment
conda activate DiscoSNP

run_discoSnp++.sh -r $fq_list \
        -G $reference\
        --bwa_path ~/.conda/envs/DiscoSNP/bin/ -p Disco_Out -u 16
mv Disco_Out* $SimPath/$data_path/Disco_Out/



#####
#####START LOFREQ
#####
echo "Start LoFreq"

#Start LoFreq environment
conda activate LoFreq

lofreq call-parallel --pp-threads 16 \
        -f $reference\
        -o $SimPath/$data_path/Freq_Out/FreqOut.vcf $bam_file 



#####
#####START STRELKA
#####
echo "Start Strelka"

#Start Strelka environment
conda activate Strelka

configureStrelkaGermlineWorkflow.py --bam $bam_file  \
        --referenceFasta $reference \
        --runDir $SimPath/$data_path/Strelka_Stuff

python $SimPath/$data_path/Strelka_Stuff/runWorkflow.py -m local --quiet #-j 16
mv $SimPath/$data_path/Strelka_Stuff/results/variants/variants.vcf.gz $SimPath/$data_path/Strelka_Out/
gunzip $SimPath/$data_path/Strelka_Out/variants.vcf.gz



#####
#####START BACTSNP
#####
#echo "Start BactSNP"

#Start BactSNP environment
#conda activate bactsnp

#bactsnp -q $SimPath/FastqlistBact.txt \
#        -r  $reference \
#        -o $SimPath/$data_path/BactSNP_Stuff




#####
#####DO BENCHMARKING
#####
echo "Start Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq


python $SimPath/Workflows/Compare_vcf.py -i $SimPath/$data_path/Disco_Out/Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent_for_IGV.vcf \
	$SimPath/$data_path/Strelka_Out/variants.vcf $SimPath/$data_path/Freq_Out/FreqOut.vcf -G $SimPath/Full3SNPLog.csv

