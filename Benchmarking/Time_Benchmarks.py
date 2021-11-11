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
    info = "Input time and memory files"
    parser = argparse.ArgumentParser(description=info)
    parser.add_argument('-t', '--input_time', nargs='+', required=True,
                        help='Raw time file that needs to be parsed')
    return parser.parse_args(cmdline_params)
###Parsing command line prompts###




if __name__ == '__main__':
    opts = parse_cmdline_params(sys.argv[1:])
    time_files = opts.input_time  #input list of time files


    df=pd.DataFrame(columns=["Variant_Caller","Time","Memory"]) #Empty dataframe to append to
    
    for f in time_files:
        with open(f,"r") as file:
            
            ###Grab time and memory from files
            for line in file:
                if "Elapsed (wall clock)" in line:
                    wct, time = line.split(' (h:mm:ss or m:ss): ')
                if "Maximum resident set size" in line:
                    mrs, mem = line.split(' (kbytes): ')

            ###Reformat times
            (h, ms) = time.split(':')
            (m, s) = ms.split('.')
            dtime = int(h) * 60 + int(m) + int(s)/60  #convert to decimal time

            ###Reformat memory
            mem = mem[:-1]  #remove newline
            Mmem = int(mem)/1000   #convert to MB


            ###Extract Dataset Names
            Call_name = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/S[0-9]*/M[0-9]*\.*[0-9]*/(.*?)/.*", f).group(1) #Extract only the Variant Caller's name
            Coverage = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/S[0-9]*/(M[0-9]*\.*[0-9]*)/.*", f).group(1) #Extract only the # of reads in dataset
            Subset = re.search("/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/(S[0-9]*)/.*", f).group(1) #Extract only the # of reference genomes in dataset


            ###Create DataFrame
            Addtimeframe = pd.DataFrame({'VCaller': Call_name,'Subset':Subset,'Dataset':Coverage,'Time':[dtime], 'Memory':[Mmem]})
            #print(Addtimeframe)
            
            ###Output DataFrame to file
            time_bench_file="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run/TimeBenchmark.csv"

            if os.path.exists(time_bench_file):                    #If file already made, append Addtimeframe to it
                Intimeframe = pd.read_csv(time_bench_file)             #Old file
                Outtimeframe = pd.concat([Intimeframe,Addtimeframe])    #Append new file to old file
                Outtimeframe.to_csv(time_bench_file,index=False)
            else:                                           #If file not made, make it with the Addtimeframe
                Addtimeframe.to_csv(time_bench_file,index=False)





