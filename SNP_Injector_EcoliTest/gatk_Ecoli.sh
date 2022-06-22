#!/bin/bash

bowtie2-build -f Ecoli_Ref.fasta GATK_Stuff/Ecoli_bowtie

bowtie2 --rg-id 100k_test --rg SM:AME1 --rg PL:Illumina \
        -p 10 -x GATK_Stuff/Ecoli_bowtie -1 SimSNP_reads_R1.fastq -2 SimSNP_reads_R2.fastq -S Bow_Out.sam

samtools view -S -b Bow_Out.sam > Bow_Out.bam #Convert sam to bam
samtools sort Bow_Out.bam -o Bow_sorted.bam #Sort bam file
samtools index Bow_sorted.bam
samtools faidx Ecoli_Ref.fasta

gatk CreateSequenceDictionary -R Ecoli_Ref.fasta
#Just do it on this sample for now
gatk HaplotypeCaller\
        -R Ecoli_Ref.fasta\
        -I Bow_sorted.bam \
        -O GATKOut_Jesse.vcf -ploidy 1

###This is for cohort-based variant calling (do this eventually with multiple samples)
#gatk HaplotypeCaller\
#        -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta\
#        -I /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam\
#        -O GATKOut_Jesse.gvcf -ERC GVCF -ploidy 1



