#!/bin/bash

#100 bacteria 5 viruses and 10 archaea 
#10 million reads
#zero inflated log normal coverage distribution
#novaseq error profile/sequencing technology
#10 cpus
#seed is LEET

iss generate --ncbi bacteria viruses archaea -U 100 5 10 -n 10M --coverage zero_inflated_lognormal --model novaseq \
	--output SynthData/Mixed_Nova1/ncbi_1337_ --cpu 10 --seed 1337
