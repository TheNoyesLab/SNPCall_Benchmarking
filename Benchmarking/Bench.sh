#!/bin/bash

conda activate

###Run python script with 3 vcf files and known SNPs in 2 E.coli strains
python Compare_vcf.py -i ../../Disco_Out.vcf ../../FreqDoubleOut.vcf ../../Strelka_Double.vcf -G ../../DoubleSNPLog.csv
