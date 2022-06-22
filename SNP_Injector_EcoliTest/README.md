# Injecting SNPs

##Using SNP\_Injector
 - python SNP\_Injector\_Fasta.py -s 2 -r /home/noyes046/shared/projects/SNP\_Call\_Benchmarking/Simulated\_Datasets/Ecoli\_double\_ref.fasta
 - **-s** indicates # of SNP'd copies (strains)  
 - **-r** indicates a reference database to use (Default=Jesse\_full\_db.fasta)

## Scripts and files used in Injecting SNPs
 - **SNP_Injector_Fasta.py:** Inputs SNPs into original genome, outputs new genome with added SNPs (SNPReference.fasta)
   - conda activate snowflakes
   - python SNP\_Injector\_Fasta.py
 - **SimSNP.sh:** Simulates perfect reads from new genome w/SNPs
   - conda activate InSilicoSeq
 - **Disco_Ecoli.sh:** Running DiscoSNP on Simulated Reads w/SNPs
   - conda activate DiscoSnp
 - **gatk_Ecoli.sh:** Running GATK on Simulated Reads w/SNPs
   - conda activate GATK
   - Also creates E. coli bowtie2 database & alignment in GATK\_Stuff/

## References & Datasets
 - **Ecoli_Ref.fasta:** Original E. coli complete reference genome
 - **SNPReference.fasta:** New genome with added SNPs recorded in (SNPLog.csv)
 - **SNPLog.csv:** CSV formatted record of input SNPs
 - **Fastqlist.txt:** List of Fastq files for DiscoSNP to run through

## Output files
 - **Disco_Out_k_31_c_3_D_100_P_3_b_0_coherent_for_IGV.vcf:** DiscoSNP called SNPs in order, ready for IGV
 - **GATKOut_Jesse.vcf:** GATK called SNPs
