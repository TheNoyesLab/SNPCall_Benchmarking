# SNPCall_Benchmarking
Repo for scripts and files used in benchmarking variant callers

# Important Directories
## projects/SNP\_Call\_Benchmarking/*Benchmarking\_Run*:
- Directory containing synthetic reads, variant caller output, and benchmarks
- All output of Benchmarking Workflow goes here

## SNPCall_Benchmarking/**Workflow**:
Production-stage scripts that form the core Benchmarking workflow.
### Genesis.sh
  - Script performing directory setup, SNP generation, read synthesis, and alignment

### MultiCaller.sh
  - Script running variant callers and benchmarking on data generated by Genesis.sh

### Single_scripts/
  - Core workflow broken up into individual scripts (read generation,alignment,individual variant callers, etc)

### SNP_Injector_Fasta.py
  - Python code in Genesis.sh used to "inject" SNPs into fasta files
  - Creates a log of input SNPs and genome locations

