#!/bin/bash

gatk CreateSequenceDictionary -R Jesse_full_curated_db.fasta

samtools faidx Jesse_full_curated_db.fasta
