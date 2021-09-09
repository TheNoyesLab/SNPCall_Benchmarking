#!/bin/bash

###Arguments
while getopts f:r:b: flag
do
    case "${flag}" in
        f) fq_list=${OPTARG};;
        r) reference=${OPTARG};;
	b) bam_file=${OPTARG};;
    esac
done


###Set up a path
SimPath="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets"
###Set up default values 
reference=${reference:-"$SimPath/Ecoli_Ref.fasta"}
fq_list=${fq_list:-"$SimPath/M5/Fastqlist.txt"}
bam_file=${bam_file:-"$SimPath/M5/Ecoli_Ref_sorted.bam"}

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
mv Disco_Out* $SimPath/M5/Disco_Out/



#####
#####START LOFREQ
#####
echo "Start LoFreq"

#Start LoFreq environment
conda activate LoFreq

lofreq call-parallel --pp-threads 16 \
        -f $reference\
        -o $SimPath/M5/Freq_Out/FreqOut.vcf $bam_file 



#####
#####START STRELKA
#####
echo "Start Strelka"

#Start Strelka environment
conda activate Strelka

configureStrelkaGermlineWorkflow.py --bam $bam_file  \
        --referenceFasta $reference \
        --runDir $SimPath/M5/Strelka_Stuff

python $SimPath/M5/Strelka_Stuff/runWorkflow.py -m local --quiet #-j 16



#####
#####START BACTSNP
#####
echo "Start BactSNP"

#Start BactSNP environment
conda activate bactsnp

bactsnp -q $SimPath/FastqlistBact.txt \
        -r  $reference
        -o $SimPath/M5/BactSNP_Stuff




