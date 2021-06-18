import os
import sys
import gzip
import argparse
import glob
import time
import platform
import random
import numpy
from Bio import SeqIO  #requires biopython



#####Original nuc -> New, Different Nuc
def only_snp(old_nt,tot_snp):
    ###Choose new nucleotide != old nucleotide
    newnt=[]   #empty list of new nucleotides
    it=0       #iterator starts at 0

    while it < tot_snp:   #loop through only as many as total # of snps
        ntlist=['A','C','T','G']   #full list of nt's


        newlist=[nuc for nuc in ntlist if nuc not in old_nt[it]] #list on only possible new nt's

        onent=numpy.random.choice(newlist,1)                    #pick random nuc's to replace old
        #print("New SNP",onent[0])
        newnt.append(onent[0])                                  #add to list of new nucleotides (SNPs)
        it=it+1                                                 #increase iterator

    print("New SNPs:",newnt)
    return(newnt)


#####Main SNP RNG function
def random_snp(old_sequence,read_len):

    p=0.01   #1 percent of nt's are SNPs on average
    #Binomially distributed SNPs
    SnpTot= numpy.random.binomial(read_len,p,1)   #output number of snps to inject
    #print("Total SNPs",SnpTot)
    Ntindex=numpy.random.choice(range(read_len),SnpTot,replace=False)   #pick random nucleotides to replace (number to replace is binomially distributed)
    print("\n","Index of Snps:",Ntindex)

    print(old_sequence) #print the sequence, it's pretty

    oldnt=[old_sequence[i] for i in Ntindex]   #The old nucleotides at the locus of SNPs
    print("Old_nt:",oldnt)


    newnt=only_snp(oldnt,SnpTot)     #Inputs old nucs, outputs new SNPs


    Snpswap = {Ntindex[i]: newnt[i] for i in range(len(Ntindex))}     #Create a dictionary of index -> SNP
    print("Snpswap Dictionary:",str(Snpswap))

    return




#####
#####MAIN SECTION
#####

if __name__ == '__main__':
    n=0 #Number of records to go through
    for record in SeqIO.parse("ncbi_8008__R1.fastq","fastq"):
        #print(record.seq,record.letter_annotations["phred_quality"])

        n=n+1
        Oldseq=str(record.seq)
        readlength=len(Oldseq)  #length of each record's read
        #print(SnpTot)

        random_snp(Oldseq,readlength)    #Generate a random SNP

        if n>=10:      #Only the first 10 entries
            break
