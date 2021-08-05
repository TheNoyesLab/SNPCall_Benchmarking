#!/bin/bash

sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p'  Meta_Out.vcf > Meta_Out_Fix.vcf #Just show ALT allele, no numbersA
