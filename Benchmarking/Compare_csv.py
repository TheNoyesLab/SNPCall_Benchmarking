#!/usr/bin/env python
import sys
import argparse
import io
import os
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

    print("True Positives:",TP)
    print("False Positives:",FP)
    print("False Negatives:",FN)

    print("Precision:",Precision)
    print("Recall:",Recall)
    print("Harmonic Mean of Precision and Recall i.e. the F-score:",Fscore,"\n")



###Read in all of the vcf-like files manually -- now can be done in command line
# GATK=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/GATKOut_Jesse.vcf")
# GATKMulti=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/GATKMultiOut.vcf")
# LoFreq=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/FreqOut.vcf")
# LoFreqMulti=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/FreqMultiOut.vcf")
# Meta=pd.read_csv("/Users/Gawdcomplex/Desktop/NoyesLab/Meta_Out_Fix.vcf",sep="\t",names=["CHROM","DASH","POS","REF","QUAL","ALT"])
# Disco=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/Disco_Out.vcf")
# DubStrelka=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/Strelka_Double.vcf")
# DubFreq=read_vcf("/Users/Gawdcomplex/Desktop/NoyesLab/FreqDoubleOut.vcf")
#
# Log=pd.read_csv("/Users/Gawdcomplex/Desktop/NoyesLab/SNPLog.csv")
# Log1=pd.read_csv("/Users/Gawdcomplex/Desktop/NoyesLab/SNPLog1.csv")
# DubLog=pd.read_csv("/Users/Gawdcomplex/Desktop/NoyesLab/DoubleSNPLog.csv")

# print("VARIANT CALLER BENCHMARKING","\n","\n")
# print("GATK-HC")
# #Bench(Log,GATK)
# print("LoFreq")
# #Bench(Log,LoFreq)
# print("MetaSNV")
# #Bench(Log,Meta)
# print("GATKMulti")
# Bench(Log1,GATKMulti)
# print("LoFreqMulti")
# Bench(Log1,LoFreqMulti)
#
# print("DiscoSNP")
# Bench(DubLog,Disco)
#
# print("Strelka")
# Bench(DubLog,DubStrelka)
#
# print("LoFreq")
# Bench(DubLog,DubFreq)

print("\n","\n","\n")


#####MAIN FUNCTIONS
if __name__ == '__main__':
    opts = parse_cmdline_params(sys.argv[1:])
    bact_file = opts.input_bact  #input BactSNP file
    meta_file = opts.input_meta #input metaSNV file
    gold_file = pd.read_csv(opts.gold_standard) #input known SNPs in csv

    if bact_file is not None:
        print("BactSNP") 
        bact_frame = pd.read_csv(bact_file,sep="\t",header=0,names=["CHROM","POS","REF","ALT"]) #load into DF replacing column names
        Bench(gold_file,bact_frame)
    if meta_file is not None:
        print("MetaSNV")
        meta_frame = pd.read_csv(meta_file,sep="\t",names=["CHROM","DASH","POS","REF","QUAL","ALT"]) #load into DF add column names
        Bench(gold_file,meta_frame)
