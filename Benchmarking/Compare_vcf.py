#!/usr/bin/env python
import sys
import argparse
import io
import os
import os.path
import re
import pandas as pd
import numpy as np


#####
#####HELPER FUNCTIONS
#####

###Parsing command line prompts###
def parse_cmdline_params(cmdline_params):
    info = "Input vcf files and known SNP file"
    parser = argparse.ArgumentParser(description=info)
    parser.add_argument('-i', '--input_vcf', nargs='+', required=True,
                        help='Input a sequence of vcf files to be tested')
    parser.add_argument('-G', '--gold_standard', required=True,
                        help='Input a gold standard csv to test against')
    return parser.parse_args(cmdline_params)
###Parsing command line prompts###


###Reading vcf files as csvs
def read_vcf(path):
    with open(path, 'r') as f:
        lines = [l for l in f if not l.startswith('##')]   #Remove ## lines at top
    return pd.read_csv(
        io.StringIO(''.join(lines)),
        dtype={'#CHROM': str, 'POS': int, 'ID': str, 'REF': str, 'ALT': str,
               'QUAL': str, 'FILTER': str, 'INFO': str},
        sep='\t'
    ).rename(columns={'#CHROM': 'CHROM'})  #Create pandas csv from remaining file
###Reading vcf files as csvs




#################BELOW THEE LIES THE BENCHMARKS

def Bench(Log,Calldf):

    ###MATCHING POSITION AND SNP
    TPList=pd.merge(Log,Calldf, how="inner",on=['CHROM','POS','ALT','REF'])   #Input ALT in Log at POS match ALT called by GATK at POS

    RealP=len(Log.index)    #All ACTUAL variants in SNP_Log.csv
    PredP=len(Calldf.index)  #All PREDICTED variants called by GATK
    TP=len(TPList.index)
    FP=PredP-TP         #Total number of predicted positives - True Positives
    FN=RealP-TP         #Total number of real positives - True Positives

    #Benchmarking Metrics
    Precision=TP/PredP  #True positives over # of predicted positives (the # of SNP Caller calls)
    Recall=TP/RealP     #True positives over # of Actual positives
    Fscore=2*(Precision*Recall)/(Precision+Recall)        #Harmonic Mean of Precision & Recall
    
    print("Variant Caller:",Call_name)
    print("Number of Reads:", Coverage)
    print("Data Subset:", Subset)
    print("True Positives:",TP)
    print("False Positives:",FP)
    print("False Negatives:",FN)

    print("Precision:",Precision)
    print("Recall:",Recall)
    print("Harmonic Mean of Precision and Recall i.e. the F-score:",Fscore,"\n")
    

    ###Making Dataframes for output into files
    Adddict = {'VCaller': Call_name,'Subset':Subset,'Dataset':Coverage,'TP': [TP], 'FP': [FP], 'FN': [FN], 'Precision': [Precision], 'Recall': [Recall], 'F-score': [Fscore]}
    Addframe = pd.DataFrame(data=Adddict) #Make dataframe to add to current file
    #print(Addframe)


    if os.path.exists(out_file):                    #If file already made, append Addframe to it
        Inframe = pd.read_csv(out_file)             #Old file
        Outframe = pd.concat([Inframe,Addframe])    #Append new file to old file
        Outframe.to_csv(out_file,index=False)
    else:                                           #If file not made, make it with the Addframe
        Addframe.to_csv(out_file,index=False)


    #return Outframe



print("\n","\n","\n")


#####MAIN FUNCTIONS
if __name__ == '__main__':
    opts = parse_cmdline_params(sys.argv[1:])
    vcf_files = opts.input_vcf  #input list of vcfs
    gold_file = pd.read_csv(opts.gold_standard) #input known SNPs in csv
    out_file = "/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/Benchmark.csv"    


    for f in vcf_files:
        vcf_frame = read_vcf(f)
        Call_name = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/S[0-9]*/M[0-9]*\.*[0-9]*/(.*?)/.*", f).group(1) #Extract only the Variant Caller's name
        Coverage = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/S[0-9]*/(M[0-9]*\.*[0-9]*)/.*", f).group(1) #Extract only the # of reads in dataset
        Subset = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/(S[0-9]*)/.*", f).group(1) #Extract only the # of reference genomes in dataset
        #print(Call_name)            #Print the caller's name
        #print(Coverage)             #Print the read count of dataset
        #print(Subset)               #Print the number of references in the dataset
        Bench(gold_file,vcf_frame)  #Do benchmarking


