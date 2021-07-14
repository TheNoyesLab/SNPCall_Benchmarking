#Reference Databases

- *dbDownload.sh:* Script that downloads and prepares a RefSeq database
  * Uses _conda activate GATK_
  - Download all reference genomes from RefSeq
  - Moves and unzips all fna.gz files
  - Concatenates all files into Jesse\_full\_db.fasta
