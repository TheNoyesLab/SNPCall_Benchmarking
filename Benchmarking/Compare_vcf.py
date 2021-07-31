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

x=5
print(x)

print(x+696969)

GATK=read_vcf('/Users/Gawdcomplex/Desktop/NoyesLab/GATKOut_Jesse.vcf')
LoFreq=read_vcf('/Users/Gawdcomplex/Desktop/NoyesLab/FreqOut.vcf')
Log=pd.read_csv('/Users/Gawdcomplex/Desktop/NoyesLab/SNPLog.csv')

# #print(GATK.to_string())
# matchG=GATK['ALT'][GATK['POS'].isin(LoFreq['POS'])]
# matchL=LoFreq['ALT'][LoFreq['POS'].isin(GATK['POS'])]
# nomatchG=GATK['POS'][~GATK['POS'].isin(LoFreq['POS'])]
# nomatchL=LoFreq['POS'][~LoFreq['POS'].isin(GATK['POS'])]
# print("MatchG",len(list(matchG)))
# print("MatchL",len(list(matchL)))
# print("No Match G",len(list(nomatchG))," ",list(nomatchG))
# print("No Match L",len(list(nomatchL))," ",list(nomatchL))
# print("GATK Muts",len(list(GATK['POS'])))
# print("LoFreq Muts",len(list(LoFreq['POS'])))






#################BELOW THEE LIES THE BENCHMARKS

def Bench(Log,Calldf):
    TPList=Log['New_SNP'][Log['Reference_Location'].isin(Calldf['POS'])]  #Input in Log & called by GATK
    FPList=Calldf['ALT'][~Calldf['POS'].isin(Log['Reference_Location'])]   #Called by GATK, not in input Log
    FNList=Log['New_SNP'][~Log['Reference_Location'].isin(Calldf['POS'])] #Input by Log, not called by GATK
    PredPos=len(Calldf.index)  #Total number of variants Called
    ActPos=len(Log.index)
    Precision=len(list(TPList))/PredPos
    Recall=len(list(TPList))/ActPos
    Fscore=2*(Precision*Recall)/(Precision+Recall)

    print("# of SNPs input in Log:",len(list(Log['Reference_Location'])))
    print("True Positives:",len(list(TPList)))
    print("False Positives:",len(list(FPList)))
    print("False Negatives:",len(list(FNList)))
    print("Precision:",Precision)
    print("Recall:",Recall)
    print("Harmonic Mean of Precision and Recall i.e. the F-score:",Fscore,"\n")

print("VARIANT CALLER BENCHMARKING","\n","\n")
print("GATK-HC")
Bench(Log,GATK)
print("LoFreq")
Bench(Log,LoFreq)

