## Nextflow Variant Calling Pipeline

A bioinformatics pipeline for automated variant calling from paired-end FASTQ sequencing data using industry-standard tools.

## Pipeline Workflow
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

## Features

- Automated end-to-end variant calling workflow
- Parallel processing of multiple samples
- Comprehensive HTML quality reports
- Detailed execution reports and timelines
- Conda environment support
- Reproducible and portable across systems