#!/bin/bash

bowtie2-build -f /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta GATK_Stuff/Multi_bowtie

bowtie2 --rg-id 100k_test --rg SM:Multi --rg PL:Illumina \
        -p 10 -x GATK_Stuff/Multi_bowtie -1 Simmy_reads_R1.fastq -2 Simmy_reads_R2.fastq -S Bow_Multi_Out.sam

samtools view -S -b Bow_Multi_Out.sam > Bow_Multi_Out.bam #Convert sam to bam
samtools sort Bow_Multi_Out.bam -o Bow_Multi_sorted.bam #Sort bam file
samtools index Bow_Multi_sorted.bam

gatk CreateSequenceDictionary -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta
#Just do it on this sample for now
gatk HaplotypeCaller\
        -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta\
        -I Bow_Multi_sorted.bam \
        -O GATKMultiOut.vcf -ploidy 1

###This is for cohort-based variant calling (do this eventually with multiple samples)
#gatk HaplotypeCaller\
#        -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta\
#        -I /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam\
#        -O GATKOut_Jesse.gvcf -ERC GVCF -ploidy 1



