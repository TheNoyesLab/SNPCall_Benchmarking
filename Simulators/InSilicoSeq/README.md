# How to do InsilicoSeq

_use "conda activate InSilicoSeq"_

*Generate reads downloaded from ncbi:*
- iss generate
- iss generate --ncbi bacteria -u 10 --model miSeq --output ncbi_reads
- iss generate --ncbi bacteria viruses archaea -U 100 3 10 --model miSeq --output ncbi_reads

*Important flags:*
--ncbi: Type of genomes to download from NCBI RefSeq (bacteria viruses archaea only)
--model: Type of error model to use/sequencing technology (only Illumina Miseq, Hiseq, Novaseq)
--output: Prefix of output files
--genomes: A multi-fasta of the genomes to simulate (optional if using random ncbi genomes)
--n_reads, -n: Number of reads to generate (1000000 or 1M or 1000G, 1000000 by default)

--abundance: The genome abundance distributions (halfnormal exponential lognormal or 0-inflated lognormal)
--abundance_file: A tsv file with column 1 being _genome names_ and column 2 being probability (0-1)
--coverage: The coverage distributions for each genome (halfnormal exponential lognormal or 0-inflated lognormal)
--coverage: A tsv file with column 1 being _genome names_ and column 2 being X-coverage (0-100000)

--cpus: Number of cpus to use (probs 2-10)
--seed: Set a seed for random number generators
