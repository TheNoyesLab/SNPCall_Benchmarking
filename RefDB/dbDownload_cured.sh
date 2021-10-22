#!/bin/bash

#Shortcut variables
db=/home/noyes046/shared/databases/Jesse_database

#Download representative genomes from RefSeq
ncbi-genome-download --assembly-levels complete --refseq-categories representative --format fasta --genera $db/my_genera.txt bacteria

###my_genera.txt is based off of Andreu-Sanchez et. al, 2021

cd $db/refseq #change to new downloaded directory
echo "Moving and unzipping all fna.gz files"
find . -mindepth 1 -name '*.fna.gz' -type f -print -exec mv {} . \;  #move all .fna.gz file (assemblies) out
gunzip *.fna.gz

echo "Concatenating all files into Jesse_full_db.fasta"
cat *.fna > $db/Jesse_curated_db.fasta

echo "Deleting downloaded RefSeq"
#cd ..
#rm -fr refseq
