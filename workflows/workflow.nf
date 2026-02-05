include { FASTQC as FASTQC_RAW }  from '../modules/fastqc.nf'
include { FASTQC as FASTQC_TRIMMED } from '../modules/fastqc.nf'
include { CUTADAPT }              from '../modules/cutadapt.nf'
include { BWA_ALIGN }             from '../modules/bwa_align.nf'
include { SAM_TO_BAM }            from '../modules/sam_to_bam.nf'
include { SORT_BAM }              from '../modules/sort_bam.nf'
include { VARIANT_CALLING }       from '../modules/variant_calling.nf'
include { FILTER_VARIANTS }       from '../modules/filter_variants.nf'

workflow VARIANT_CALLING_PIPELINE {
    
    println "========================================"
    println "VARIANT CALLING PIPELINE"
    println "========================================"
    println "Input directory  : ${params.fastq_dir}"
    println "Reference genome : ${params.reference}"
    println "Output directory : ${params.output}"
    println "========================================"
    
    // 1. Input reads channel
    read_pairs_ch = Channel
        .fromFilePairs("${params.fastq_dir}/*_{1,2}.fastq.gz", checkIfExists: true)
    
    // 2. Create reference genome channel (collect all BWA index files)
    reference_dir_ch = Channel
        .fromPath("${params.reference}*")
        .collect()
    
    // 3. Create separate channel for just the reference FASTA
    reference_fa_ch = Channel
        .fromPath("${params.reference}")
    
    // 4. Initial QC on raw reads
    FASTQC_RAW(read_pairs_ch, '1_fastqc_raw')
    
    // 5. Trim adapters and filter quality
    CUTADAPT(FASTQC_RAW.out.reads)
    
    // 6. QC on trimmed reads
    FASTQC_TRIMMED(CUTADAPT.out.trimmed_reads, '3_fastqc_trimmed')
    
    // 7. Alignment to reference genome
    BWA_ALIGN(CUTADAPT.out.trimmed_reads, reference_dir_ch)
    
    // 8. Convert SAM to BAM
    SAM_TO_BAM(BWA_ALIGN.out.sam)
    
    // 9. Sort BAM files
    SORT_BAM(SAM_TO_BAM.out.bam)
    
    // 10. Call variants
    VARIANT_CALLING(SORT_BAM.out.sorted_bam, reference_fa_ch)
    
    // 11. Filter variants
    FILTER_VARIANTS(VARIANT_CALLING.out.raw_vcf)
}

workflow.onComplete {
    println "========================================"
    println "Pipeline Complete!"
    println "Status: ${workflow.success ? 'SUCCESS' : 'FAILED'}"
    println "Time: ${workflow.duration}"
    println "Results: ${params.output}"
    println "========================================"
}