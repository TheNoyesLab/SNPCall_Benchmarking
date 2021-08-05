#!/usr/bin/env python

import io
import os
import pandas as pd
import numpy as np


def read_vcf(path):
    with open(path, 'r') as f:
        lines = [l for l in f if not l.startswith('##')]
    return pd.read_csv(
        io.StringIO(''.join(lines)),
        dtype={'#CHROM': str, 'POS': int, 'ID': str, 'REF': str, 'ALT': str,
               'QUAL': str, 'FILTER': str, 'INFO': str},
        sep='\t'
    ).rename(columns={'#CHROM': 'CHROM'})



###Read in all of the vcf-like files
GATK=read_vcf('/Users/Gawdcomplex/Desktop/NoyesLab/GATKOut_Jesse.vcf')
LoFreq=read_vcf('/Users/Gawdcomplex/Desktop/NoyesLab/FreqOut.vcf')
Log=pd.read_csv('/Users/Gawdcomplex/Desktop/NoyesLab/SNPLog.csv')
###Remove excess clutter from vcfs
GATK=GATK.iloc[:,[0,1,3,4]]
LoFreq=LoFreq.iloc[:,[0,1,3,4]]

#GATK=read_vcf('/Users/Gawdcomplex/Desktop/NoyesLab/GATKOut_Jesse_copy.vcf')  #Edited GATK file for testing



#################BELOW THEE LIES THE BENCHMARKS

def Bench(Log,Calldf):

    ###MATCHING POSITION AND SNP
    TPList=pd.merge(Log,Calldf, how="inner",on=['POS','ALT','REF'])   #Input ALT in Log at POS match ALT called by GATK at POS

    RealP=len(Log.index)    #All ACTUAL variants in SNP_Log.csv
    PredP=len(Calldf.index)  #All PREDICTED variants called by GATK
    TP=len(TPList.index)
    FP=PredP-TP         #Total number of predicted positives - True Positives
    FN=RealP-TP         #Total number of real positives - True Positives

    #Benchmarking Metrics
    Precision=TP/PredP  #True positives over # of predicted positives (the # of SNP Caller calls)
    Recall=TP/RealP     #True positives over # of Actual positives
    Fscore=2*(Precision*Recall)/(Precision+Recall)        #Harmonic Mean of Precision & Recall

    print("TPLIST",TP)
    print("FPLIST",FP)
    print("FNLIST",FN)

    print("Precision:",Precision)
    print("Recall:",Recall)
    print("Harmonic Mean of Precision and Recall i.e. the F-score:",Fscore,"\n")



print("VARIANT CALLER BENCHMARKING","\n","\n")
print("GATK-HC")
Bench(Log,GATK)
print("LoFreq")
Bench(Log,LoFreq)
