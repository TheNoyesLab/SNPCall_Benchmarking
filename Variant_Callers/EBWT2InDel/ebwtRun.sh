#~/bin/bash

ebwt="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmark_Space/ebwt"

#Replace all N's in reads with A's to conform to ebwt needs
cat SimSNP_reads_R1.fastq SimSNP_reads_R2.fastq > $ebwt/SimSNP_reads_ebwt.fastq
sed -e "/^[ACTGN]*$/s/N/A/g" $ebwt/SimSNP_reads_ebwt.fastq > $ebwt/SimSNP_reads_ebwt.clean.fastq

#Use eGap to create BWT file for input into EBWT
~/Ebwt2snp/egap/eGap --lcp -o $ebwt/ebwt_Out -m 4096 $ebwt/SimSNP_reads_ebwt.clean.fastq

#Use BWT file to create SNP file 
/home/noyes046/elder099/Ebwt2snp/ebwt2InDel/build/ebwt2InDel -1 $ebwt/ebwt_Out.bwt -o $ebwt/SimSNP_test.snp

#SNP file to VCF
seqtk seq -F 'I' $ebwt/SimSNP_test.snp > $ebwt/SimSNP_ebwt_var_conversion.fastq   #SNP to FQ reads (tb aligned) #Make reads out of SNP file
bowtie2 --rg-id 100k_test --rg SM:AME1 --rg PL:Illumina \
        -p 10 -x GATK_Stuff/Ecoli_bowtie -1 $ebwt/SimSNP_ebwt_var_conversion.fastq -S $ebwt/Ebwt_SimSNP.sam   #Align bwt to Reference
/home/noyes046/elder099/Ebwt2snp/ebwt2InDel/build/sam2vcf -f Ecoli_Ref.fasta -s $ebwt/Ebwt_SimSNP.sam -v $ebwt/Ebwt_SimSNP.vcf  #Change sam to vcf
