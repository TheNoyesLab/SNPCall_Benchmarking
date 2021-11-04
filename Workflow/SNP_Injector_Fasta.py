import os
import sys
import gzip
import pandas as pd
import argparse
import random
import numpy
from Bio import SeqIO  #requires biopython


###Parsing command line prompts###
def parse_cmdline_params(cmdline_params):
    info = "Input Number of Strains"
    parser = argparse.ArgumentParser(description=info)
    parser.add_argument('-s', '--strains', required=True,
                        help='Input an integer number of genome copies')
    parser.add_argument('-r', '--ref_db', required=False, default="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta",
                        help='Input filepath of a reference database')
    return parser.parse_args(cmdline_params)
###Parsing command line prompts###





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
    opts = parse_cmdline_params(sys.argv[1:])
    num_strains = opts.strains  #input number of strains
    Ref = opts.ref_db           #input filepath of reference database
    
    
    
    filename= "/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/SNP_Injector/Jesse_full_db_" + str(num_strains) + "strain_SNP.fasta"
    file=open(filename,"w")

    SNPLog=pd.DataFrame()  #Empty DF to append SNP info to

    for strain in range(int(num_strains)):
        print("Strain Number:",strain,"\n")
        for record in SeqIO.parse(Ref,"fasta"):
            print(record.id)
            # Oldseq=record.seq
            # Desc=record.description
            # reflength=len(Oldseq)  #length of each record's reference


            Desc, New_mut_sequence, SNPDataFrame=random_snp(record)    #Generate a random SNP


            #Write a new fasta with IDs of duplictes changed
            file.writelines([">",Desc,"_",str(strain+1),"\n",str(New_mut_sequence),"\n"]) #">E coli genome H815_1" \n sequence \n ">E coli genome H815_2" \n sequence etc

            SNPLog=pd.concat([SNPLog,SNPDataFrame])
    
    SNPLog_file="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/SNP_Injector/Full" + str(num_strains) + "SNPLog.csv"
    SNPLog.to_csv(SNPLog_file,index=False)
    file.close()



    ###########################################
    #####SUBSETTING REFERENCE DATABASE & SNPLOG
    ###########################################
    for num in [5,15,25,35]:
        #Choose random reference sequences to keep
        Num_seqs=random.sample(range(35),num)
        print("Num_seqs:", Num_seqs)
        
        file=open(filename,"r")  #Open this file every loop
        counter=0
        subsamp_seq=[] #An empty list to add selected reference sequence records
        subsamp_ids=[] #An empty list to add selected reference IDs
        for record in SeqIO.parse(file,"fasta"):
            if counter in Num_seqs:
                subsamp_seq.append(record) #Add sequences based on RNG
                subsamp_ids.append(record.id[:-2]) #Add sequence ID minus strain number
                print(record.id)
            if counter in [strain+35 for strain in Num_seqs]:
                subsamp_seq.append(record) #Add second strain
                subsamp_ids.append(record.id[:-2]) #Add sequence ID minus strain number
                print(record.id)
            counter=counter+1
        file.close() #Close it and open every loop (refresh the iterator)
        out_subset="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/SNP_Injector/DB_subset" + str(num) + ".fasta"  #output location for each subset
        SeqIO.write(subsamp_seq,out_subset,"fasta")

        Sub_SNPLog=SNPLog[SNPLog["CHROM"].isin(subsamp_ids)]
        print("Unique values of Subset SNPLog:",Sub_SNPLog["CHROM"].unique())
        out_SNP_subset="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/SNP_Injector/SNPLog_subset" + str(num) + ".csv" #output location for subsets of SNP Logs
        Sub_SNPLog.to_csv(out_SNP_subset,index=False)

