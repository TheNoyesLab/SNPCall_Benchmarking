#!/bin/bash

#Download all reference genomes from RefSeq
ncbi-genome-download --refseq-categories reference --format fasta bacteria

cd refseq #change to new downloaded directory
echo "Moving and unzipping all fna.gz files"
find . -mindepth 1 -name '*.fna.gz' -type f -print -exec mv {} . \;  #move all .fna.gz file (assemblies) out
gunzip *.fna.gz

echo "Concatenating all files into Jesse_full_db.fasta"
cat *.fna > ../Jesse_full_db.fasta

echo "Deleting downloaded RefSeq"
cd ..
rm -fr refseq
