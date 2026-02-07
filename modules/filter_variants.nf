process FILTER_VARIANTS {
    publishDir "${params.output}/8_filtered", mode: 'copy'
    
    input:
    tuple val(sample_id), path(raw_vcf)
    
    output:
    tuple val(sample_id), path("${sample_id}_filtered.vcf"), emit: filtered_vcf
    
    script:
    """
    echo "Filtering variants for ${sample_id}..."
    
    ${params.bcftools_bin} filter \
        -i "QUAL>${params.min_variant_quality} && DP>${params.min_depth}" \
        ${raw_vcf} \
        -o ${sample_id}_filtered.vcf
    
    echo "Filtering complete!"
    """
}