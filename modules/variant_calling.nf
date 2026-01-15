process VARIANT_CALLING {
    publishDir "${params.output}/7_variants", mode: 'copy'
    
    input:
    tuple val(sample_id), path(sorted_bam)
    path reference_fa

    output:
    tuple val(sample_id), path("${sample_id}_raw.vcf"), emit: raw_vcf

    script:
    """
    echo "Calling variants for ${sample_id}..."

    # Step 1: Create pileup using the FASTA file only
    ${params.bcftools_bin} mpileup -f ${reference_fa} ${sorted_bam} | \
    # Step 2: Call variants
    ${params.bcftools_bin} call -mv -Ov -o ${sample_id}_raw.vcf

    echo "Variant calling complete!"
    """
}
