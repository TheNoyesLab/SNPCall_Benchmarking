#Alignment scripts and data

- *Mapping.sh:* A script that aligns 100k\_test reads to a Refseq database
  * Uses _conda activate Align_
  - Builds bowtie2 index for Jesse's RefSeq database
  - Bowtie2 aligns 100k reads to DB and adds Read-Group info (for GATK)
  - Sorts SAM alignment and makes a binary BAM (samtools)
  - Makes a BED index file (bedtools)
  - Makes a BAI bam index file (samtools) 
