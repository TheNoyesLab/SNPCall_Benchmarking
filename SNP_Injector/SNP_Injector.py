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



def random_snp(read_len):
    p=0.01   #1 percent of SNPs on average
    num= numpy.random.binomial(read_len,p,1)   #output number of snps based on binomial distribution

    return(num)



if __name__ == '__main__':
    n=0 #Number of records to go through
    for record in SeqIO.parse("ncbi_8008__R1.fastq","fastq"):
        #print(record.seq,record.letter_annotations["phred_quality"])

        n=n+1
        Oldseq=str(record.seq)
        readlength=len(Oldseq)  #length of each record's read
        SnpTot=random_snp(readlength)    #how many snps to inject
        #print(SnpTot)
        print(Oldseq)
        Ntindex=numpy.random.choice(range(readlength),SnpTot,replace=False)   #pick random nucleotides to replace (number to replace is binomially distributed)

        oldnt=[Oldseq[i] for i in Ntindex]
        print("Old_nt:",oldnt)
        newnt=numpy.random.choice(('A','C','T','G'),SnpTot)   #pick random nuc's
        print("Index of Snps:",Ntindex)
        print("New_nt:",newnt)
        Snpswap = {Ntindex[i]: newnt[i] for i in range(len(Ntindex))}
        print("Snpswap Dictionary:",str(Snpswap))

        #Midseq=

        if n>=10:
            break
#     ###Parsing command line prompts###
# def parse_cmdline_params(cmdline_params):
#     info = "Removes duplicate FASTQ entries from a FASTQ file"
#     parser = argparse.ArgumentParser(description=info)
#     parser.add_argument('-i', '--input_files', nargs='+', required=True,
#                             help='Use globstar to pass a list of sequence files, (Ex: *.fastq.gz)')
#     return parser.parse_args(cmdline_params)
#     ###Parsing command line prompts###
#
#
#
# def multi_func(q):  #Collect Q information  #Function to run in parallel
#     nucLen = len(q) - 1	    #The length of the sequence; exclude new line character
#
#     Q_scores = [ord(q[i]) - 33 for i in range(nucLen)]   #Translate to numbers and subtract 33
#     Prob = (10 ** (-Q_scores[i] / 10) for i in range(nucLen))   #Convert Q to Probabilities
#
#     #Extract the mean Q and P and Read Length for each Read
#     return sum(Q_scores) / nucLen, sum(Prob) / nucLen, nucLen
#
#
#
# #Extract Quality Scores and other sequence information
# def Pull_Phred(fastq_files):
#     for f in fastq_files: # iterate through each fastq file
#         fp = open(f, 'r')
#
#         Lines = fp.readlines()
#         Line4 = Lines[3::4] #Every 4th line (Quality scores) starting with line 4 (index 3)
#         readnum=len(Line4) #number of reads in file
#
#
#
#
#         qs = (listy[0] for listy in res) #Extract Q's as 1st element
#         ps = (listy[1] for listy in res) #Extract P's as 2nd element
#         readlen = (listy[2] for listy in res) #Extract read length as 3rd element
#
#         print("\n Number of Reads = ", readnum)
#         print("Mean Quality Score = ",sum(qs) / readnum)
#         print("Mean Probability of Error = ",sum(ps) / readnum)
#         print("Mean readlength = ", sum(readlen) / readnum)
#
#     fp.close()
#
#
# if __name__ == '__main__':
#     opts = parse_cmdline_params(sys.argv[1:])
#     fastq_files = opts.input_files  #parse input files
#
#     Pull_Phred(fastq_files) #run Phred collection
