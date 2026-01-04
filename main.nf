#!/usr/bin/env nextflow

// Import all processes from modules
include { FASTQC_RAW } from './modules/fastqc_raw.nf'
include { CUTADAPT } from './modules/cutadapt.nf'
include { FASTQC_TRIMMED } from './modules/fastqc_trimmed.nf'

// Print welcome message
println "========================================"
println "FASTQ QC PIPELINE"
println "========================================"
println "Input directory  : ${params.fastq_dir}"
println "Output directory : ${params.output}"
println "========================================"

// Main workflow - connects all steps
workflow {
    // Step 1: Find your FASTQ files
    Channel
        .fromFilePairs("${params.fastq_dir}/*_{1,2}.fastq.gz")
        .set { read_pairs_ch }
    
    // Step 2: Run FastQC on raw files
    FASTQC_RAW(read_pairs_ch)
    
    // Step 3: Run Cutadapt to trim
    CUTADAPT(FASTQC_RAW.out.reads)
    
    // Step 4: Run FastQC on trimmed files
    FASTQC_TRIMMED(CUTADAPT.out.trimmed_reads)
}

// Print completion message
workflow.onComplete {
    println "========================================"
    println "Pipeline Complete!"
    println "Status: ${workflow.success ? 'SUCCESS' : 'FAILED'}"
    println "Time: ${workflow.duration}"
    println "Results: ${params.output}"
    println "========================================"
}