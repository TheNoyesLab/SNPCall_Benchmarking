import os
import sys
import gzip
import pandas as pd
import argparse
import random
import numpy
from Bio import SeqIO  #requires biopython



#####Original nuc -> New, Different Nuc
def only_snp(old_nt,tot_snp):
    ###Choose new nucleotide != old nucleotide
    newnt=[]   #empty list of new nucleotides
    it=0       #iterator starts at 0
    ntlist=['A','C','T','G']   #full list of nt's

    while it < tot_snp:   #loop through only as many as total # of snps

        ###Dev note: Consider changing to elif statements, not logical subsetting
        newlist=[nuc for nuc in ntlist if nuc not in old_nt[it]] #list on only possible new nt's

        onent=numpy.random.choice(newlist,1)                    #pick random nuc's to replace old
        newnt.append(onent[0])                                  #add to list of new nucleotides (SNPs)

        it=it+1                                                 #increase iterator

    return(newnt)


##############################
#####Main SNP RNG function
##############################
def random_snp(record):

    ##Preparing SeqIO record data
    old_sequence=record.seq
    Desc=record.id
    ref_len=len(old_sequence)  #length of each record's reference

    ##Creating #Binomially distributed SNPs
    p=0.0001                                                           #1 percent of nt's are SNPs on average
    SnpTot= numpy.random.binomial(ref_len,p,1)                         #output number of snps to inject (number to replace is binomially distributed)
    print("Total SNPs",SnpTot)
    Ntindex=numpy.random.choice(range(ref_len),SnpTot,replace=False)   #pick random nucleotides at index to replace
    Ntindex.sort()                                                     #Ascending order


    print(old_sequence[1:20]) #print the sequence, it's pretty

    oldnt=[old_sequence[i] for i in Ntindex]   #The old nucleotides at the locus of SNPs
    newnt=only_snp(oldnt,SnpTot)               #Inputs old nucs, outputs new SNPs


    ###Loop through old sequence and mutate it
    mut_old_sequence=old_sequence.tomutable()  #Make sequence mutable so I can edit
    nucnum=0  #iterator for newnt list
    for index in Ntindex:
        mut_old_sequence[int(index)]=newnt[nucnum]        #mutate old sequence at index from list of new nucleotides
        nucnum=nucnum+1                                   #iterate through list of new nucleotides



    Ntindex= [x + 1 for x in Ntindex]
    SnpIndex_dic = { Ntindex[i]: (str(oldnt[i]),newnt[i]) for i in range(len(Ntindex)) }     #Create a dictionary of index -> SNP
    SNPIndex=pd.DataFrame.from_dict(data=SnpIndex_dic,orient='index',columns=['REF','ALT']) #Turn into a DataFrame

    SNPIndex.reset_index(inplace=True)
    SNPIndex=SNPIndex.rename(columns = {'index' : 'POS'})      #Edit Index column

    SNPIndex["CHROM"]=Desc                                     #Add genome description column
    SNPIndex=SNPIndex[['CHROM','POS','REF','ALT']]             #Reorder columns

    return Desc, mut_old_sequence, SNPIndex




#####
#####MAIN SECTION
#####

if __name__ == '__main__':
    file=open("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/DoubleSNPRef.fasta","w")
    SNPLog=pd.DataFrame()
    for record in SeqIO.parse("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/Ecoli_double_ref.fasta","fasta"):
        #print(record.seq,record.letter_annotations["phred_quality"])
        print(record.id)
        # Oldseq=record.seq
        # Desc=record.description
        # reflength=len(Oldseq)  #length of each record's reference


        Desc, New_mut_sequence, SNPDataFrame=random_snp(record)    #Generate a random SNP



        file.writelines([">",Desc,"\n",str(New_mut_sequence),"\n"])

        SNPLog=pd.concat([SNPLog,SNPDataFrame])

    SNPLog.to_csv('/home/noyes046/shared/projects/SNP_Call_Benchmarking/Simulated_Datasets/DoubleSNPLog.csv',index=False)
    file.close()
