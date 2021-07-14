#!/bin/bash

#Just do it on this sample for now
gatk HaplotypeCaller\
        -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta\
        -I /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam\
        -O GATKOut_Jesse.vcf -ploidy 1

###This is for cohort-based variant calling (do this eventually with multiple samples)
#gatk HaplotypeCaller\
#        -R /home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta\
#        -I /home/noyes046/shared/projects/SNP_Call_Benchmarking/Example_Data/TestAlign_sorted.bam\
#        -O GATKOut_Jesse.gvcf -ERC GVCF -ploidy 1



