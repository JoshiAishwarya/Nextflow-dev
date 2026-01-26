include { FASTQC as FASTQC_RAW }  from './modules/fastqc.nf'
include { FASTQC as FASTQC_TRIM } from './modules/fastqc.nf'
include { CUTADAPT }              from './modules/cutadapt.nf'
include { BWA_ALIGN }             from './modules/bwa_align.nf'
include { SAM_TO_BAM }            from './modules/sam_to_bam.nf'
include { SORT_BAM }              from './modules/sort_bam.nf'
include { VARIANT_CALLING }       from './modules/variant_calling.nf'
include { FILTER_VARIANTS }       from './modules/filter_variants.nf'

println "========================================"
println "VARIANT CALLING PIPELINE"
println "========================================"
println "Input directory  : ${params.fastq_dir}"
println "Reference genome : ${params.reference}"
println "Output directory : ${params.output}"
println "========================================"

workflow {

    Channel
        .fromFilePairs("${params.fastq_dir}/*_{1,2}.fastq.gz")
        .set { read_pairs_ch }

    reference_dir_ch = Channel
        .fromPath("${params.reference}*")
        .collect()

    reference_fa_ch  = Channel.fromPath("${params.reference}")

    FASTQC_RAW(read_pairs_ch, "1_fastqc_raw")

    CUTADAPT(FASTQC_RAW.out.reads)

    FASTQC_TRIM(CUTADAPT.out.trimmed_reads, "3_fastqc_trimmed")

    BWA_ALIGN(CUTADAPT.out.trimmed_reads, reference_dir_ch)

    SAM_TO_BAM(BWA_ALIGN.out.sam)

    SORT_BAM(SAM_TO_BAM.out.bam)

    VARIANT_CALLING(SORT_BAM.out.sorted_bam, reference_fa_ch)

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