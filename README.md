## NGS Variant Calling Pipeline
A comprehensive Nextflow pipeline for variant calling from paired-end Illumina sequencing data. This pipeline performs quality control, read trimming, alignment, and variant calling with filtering to identify high-quality genetic variants.

## Pipeline Workflow
```text
Input FASTQ files (data/*_{1,2}.fastq.gz)
        ↓
   FASTQC_RAW (Quality Control)
        ↓
    CUTADAPT (Adapter Trimming)
        ↓
  FASTQC_TRIM (Post-trim QC)
        ↓
   BWA_ALIGN (Read Alignment)
        ↓
  SAM_TO_BAM (Format Conversion)
        ↓
   SORT_BAM (BAM Sorting)
        ↓
VARIANT_CALLING (Call Variants)
        ↓
FILTER_VARIANTS (Filter Quality Variants)
        ↓
Final VCF files (results/8_filtered/)
```
## Overview

This Nextflow pipeline automates the complete variant calling workflow for next-generation sequencing (NGS) data:

1. **Quality Assessment (FastQC)** - Analyze raw FASTQ files to identify quality issues
2. **Adapter Trimming (Cutadapt)** - Remove adapters and low-quality bases
3. **Post-QC Verification (FastQC)** - Re-analyze trimmed data to verify improvements
4. **Read Alignment (BWA-MEM)** - Map cleaned reads to reference genome
5. **Format Conversion (Samtools)** - Convert SAM to compressed BAM format
6. **BAM Sorting (Samtools)** - Sort alignments by genomic coordinates
7. **Variant Calling (BCFtools)** - Identify SNPs and indels from aligned reads
8. **Variant Filtering (BCFtools)** - Filter high-quality variants for downstream analysis


## Tools Used
FastQC
Purpose: Quality control of sequencing data
Analyzes FASTQ files and generates reports showing sequence quality, GC content, adapter contamination, and duplication levels. Helps identify data quality issues before and after trimming.
Key metrics: Per-base quality scores, adapter content, sequence duplication

Cutadapt
Purpose: Adapter and quality trimming
Removes Illumina adapter sequences and trims low-quality bases from read ends. Uses quality threshold of 20 and minimum length of 20bp to ensure only high-quality sequences proceed to alignment.
Adapters removed: TruSeq Universal and Indexed adapters

BWA
Purpose: Read alignment to reference genome
Uses BWA-MEM algorithm to efficiently map short reads (70bp-1Mbp) to the reference genome. Handles mismatches and gaps, making it suitable for detecting SNPs and small indels.
Requirements: Reference genome must be indexed with bwa index

Samtools
Purpose: Alignment file manipulation
Converts SAM text files to compressed binary BAM format (5-10x smaller), then sorts alignments by genomic coordinates. Sorting is required for variant calling and enables indexed access.
Functions used: view (conversion), sort (coordinate sorting)

BCFtools
Purpose: Variant calling and filtering
Calling: Uses mpileup to generate base pileup, then call to identify SNPs and indels with quality scores.
Filtering: Removes low-confidence variants using filters: QUAL>20 (variant quality) and DP>10 (read depth).
Output: VCF files with high-quality genetic variants

Nextflow
Purpose: Workflow management
Orchestrates the entire pipeline, manages dependencies, enables parallelization, and provides resume capability. Generates execution reports and timelines for monitoring.
Benefits: Reproducible, portable, and scalable


## Features
- Automated end-to-end variant calling workflow
- Parallel processing of multiple samples
- Comprehensive HTML quality reports
- Detailed execution reports and timelines
- Conda environment support
- Reproducible and portable across systems


## How to Clone the Repository
git clone https://github.com/JoshiAishwarya/Nextflow-dev.git
cd nextflow-pipeline


## Create, Activate and Deactivate Conda Environment
conda env create -f environment.yml
conda activate bnf
conda deactivate

## Prepare Reference Genome
# Create directory
mkdir -p reference_genome

# Place your reference FASTA file (e.g., chr22.fa) in reference_genome/

# Index the reference genome for BWA
bwa index reference_genome/chr22.fa


## How to Run the Pipeline
nextflow run main.nf

# Resume a failed run (continues from last successful step)
nextflow run main.nf -resume