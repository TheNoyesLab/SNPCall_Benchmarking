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


#####Main SNP RNG function
def random_snp(old_sequence,ref_len):

    p=0.0001   #1 percent of nt's are SNPs on average
    #Binomially distributed SNPs
    SnpTot= numpy.random.binomial(ref_len,p,1)   #output number of snps to inject (number to replace is binomially distributed)
    print("Total SNPs",SnpTot)
    Ntindex=numpy.random.choice(range(ref_len),SnpTot,replace=False)   #pick random nucleotides at index to replace
    Ntindex.sort()    #Ascending order
    print("\n","Index of Snps:",Ntindex)

    print(old_sequence[1:20]) #print the sequence, it's pretty

    oldnt=[old_sequence[i] for i in Ntindex]   #The old nucleotides at the locus of SNPs


    newnt=only_snp(oldnt,SnpTot)     #Inputs old nucs, outputs new SNPs

    mut_old_sequence=old_sequence.tomutable()  #Make sequence mutable so I can edit



    ###Loop through old sequence and mutate it
    nucnum=0  #iterator for newnt list
    for index in Ntindex:

        mut_old_sequence[int(index)]=newnt[nucnum]        #mutate old sequence at index from list of new nucleotides
        nucnum=nucnum+1         #iterate through list of new nucleotides

        #print("Mutation:",old_sequence[index],"--->",mut_old_sequence[index])


    SnpIndex_dic = { Ntindex[i]: (str(oldnt[i]),newnt[i]) for i in range(len(Ntindex)) }     #Create a dictionary of index -> SNP
    SNPIndex=pd.DataFrame.from_dict(data=SnpIndex_dic,orient='index',columns=['Old_Nuc','New_SNP']) #Turn into a DataFrame
    SNPIndex.reset_index(inplace=True)
    SNPIndex=SNPIndex.rename(columns = {'index' : 'Reference_Location'})

    return mut_old_sequence, SNPIndex




#####
#####MAIN SECTION
#####

if __name__ == '__main__':
    for record in SeqIO.parse("Ecoli_Ref.fasta","fasta"):
        #print(record.seq,record.letter_annotations["phred_quality"])

        Oldseq=record.seq
        Desc=record.description
        reflength=len(Oldseq)  #length of each record's reference


        New_mut_sequence, SNPDataFrame=random_snp(Oldseq,reflength)    #Generate a random SNP

        ###Check that these do in fact replace the old nukes
        #print(Oldseq[next(iter(Snpswap_dic.keys()))-4:next(iter(Snpswap_dic.keys()))+6])
        #print(New_mut_sequence[next(iter(Snpswap_dic.keys()))-4:next(iter(Snpswap_dic.keys()))+6])

        file=open("SNPReference.fasta","w")
        file.writelines([">",Desc,"\n",str(New_mut_sequence),"\n"])
        file.close()

        SNPDataFrame.to_csv('SNPLog.csv',index=False)
