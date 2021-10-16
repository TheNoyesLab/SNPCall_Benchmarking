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
    parser.add_argument('-b', '--input_bact', required=False,
                        help='Input a vcf-like file from BactSNP')
    parser.add_argument('-m', '--input_meta',  required=False,
                        help='Input a vcf-like file from MetaSNV')
    parser.add_argument('-G', '--gold_standard', required=True,
                        help='Input a gold standard csv to test against')
    return parser.parse_args(cmdline_params)
###Parsing command line prompts###





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
    print("True Positives:",TP)
    print("False Positives:",FP)
    print("False Negatives:",FN)

    print("Precision:",Precision)
    print("Recall:",Recall)
    print("Harmonic Mean of Precision and Recall i.e. the F-score:",Fscore,"\n")


    ###Making Dataframes for output into files
    Adddict = {'VCaller': Call_name,'Dataset':Coverage,'TP': [TP], 'FP': [FP], 'FN': [FN], 'Precision': [Precision], 'Recall': [Recall], 'F-score': [Fscore]}
    Addframe = pd.DataFrame(data=Adddict) #Make dataframe to add to current file
    print(Addframe)


    if os.path.exists(out_file):                    #If file already made, append Addframe to it
        Inframe = pd.read_csv(out_file)             #Old file
        Outframe = pd.concat([Inframe,Addframe])    #Append new file to old file
        Outframe.to_csv(out_file,index=False)
    else:                                           #If file not made, make it with the Addframe
        Addframe.to_csv(out_file,index=False)


print("\n","\n","\n")


#####MAIN FUNCTIONS
if __name__ == '__main__':
    opts = parse_cmdline_params(sys.argv[1:])
    bact_file = opts.input_bact  #input BactSNP file
    meta_file = opts.input_meta #input metaSNV file
    gold_file = pd.read_csv(opts.gold_standard) #input known SNPs in csv
    out_file = "/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/Benchmark.csv"


    if bact_file is not None:
        print("BactSNP") 
        bact_frame = pd.read_csv(bact_file,sep="\t",header=0,names=["CHROM","POS","REF","ALT"]) #load into DF replacing column names
        Call_name = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/M[0-9]*/(.*?)/.*", bact_file).group(1) #Extract only the Variant Caller's name
        Coverage = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/(M[0-9]*)/.*", bact_file).group(1) #Extract only the # of reads in dataset
        print(Call_name)            #Print the caller's name
        print(Coverage)             #Print the read count of dataset
        Bench(gold_file,bact_frame)


    if meta_file is not None:
        print("MetaSNV")
        meta_frame = pd.read_csv(meta_file,sep="\t",names=["CHROM","DASH","POS","REF","QUAL","ALT"]) #load into DF add column names
        Call_name = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/M[0-9]*/(.*?)/.*", meta_file).group(1) #Extract only the Variant Caller's name
        Coverage = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/(M[0-9]*)/.*", meta_file).group(1) #Extract only the # of reads in dataset
        print(Call_name)            #Print the caller's name
        print(Coverage)             #Print the read count of dataset
        Bench(gold_file,meta_frame)


