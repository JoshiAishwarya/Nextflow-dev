# Nextflow FASTQ Quality Control Pipeline

![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A521.04.0-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)

A bioinformatics pipeline for automated quality control and preprocessing of FASTQ sequencing data using FastQC and Cutadapt.

## 📋 Overview

This Nextflow pipeline automates the quality control workflow for next-generation sequencing (NGS) data:

1. **Quality Assessment (FastQC)** - Analyze raw FASTQ files to identify quality issues
2. **Adapter Trimming (Cutadapt)** - Remove adapters and low-quality bases
3. **Post-QC Verification (FastQC)** - Re-analyze trimmed data to verify improvements

## 🌟 Features

- ✅ Automated end-to-end QC workflow
- ✅ Parallel processing of multiple samples
- ✅ Comprehensive HTML quality reports
- ✅ Detailed execution reports and timelines
- ✅ Conda environment support
- ✅ Reproducible and portable across systems

## 🛠️ Pipeline Workflow

```
Input FASTQ files (data/*.fastq.gz)
         ↓
    FASTQC_RAW
         ↓
   Quality Reports (HTML/ZIP)
         ↓
     CUTADAPT
         ↓
   Trimmed FASTQ files
         ↓
  FASTQC_TRIMMED
         ↓
   Final Quality Reports
```

## 📁 Project Structure

```
nextflow-dev/
├── main.nf              # Main pipeline script
├── nextflow.config      # Configuration file
├── README.md            # Project documentation
├── .gitignore          # Git ignore rules
└── data/               # Input FASTQ files (not tracked)
    └── *.fastq.gz
```

## 🔧 Prerequisites

- **Nextflow** ≥ 21.04.0
- **Java** ≥ 11
- **FastQC** 
- **Cutadapt**
- **Conda** (recommended)