#!/usr/bin/env python

import sys
import argparse
import io
import os
import os.path
import re
import pandas as pd
import numpy as np



if __name__ == '__main__':

    ###########################################
    #####Merge the Accuracy and Time Benchmarks
    ###########################################
    acc_bench_file="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/Benchmark.csv"
    acc_df=pd.read_csv(acc_bench_file) #Accuracy benchmarks file
    time_bench_file="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/TimeBenchmark.csv"
    time_df=pd.read_csv(time_bench_file)
    
    All_df=pd.merge(acc_df,time_df, how="inner",on=['VCaller','Subset','Dataset'])

    all_out_file="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/All_Benchmarks.csv"
    All_df.to_csv(all_out_file,index=False)
