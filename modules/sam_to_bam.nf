process SAM_TO_BAM {
    publishDir "${params.output}/5_bam", mode: 'copy'
    
    input:
    tuple val(sample_id), path(sam)
    
    output:
    tuple val(sample_id), path("${sample_id}.bam"), emit: bam
    
    script:
    """
    echo "Converting SAM to BAM for ${sample_id}..."
    
    ${params.samtools_bin} view -S -b ${sam} > ${sample_id}.bam
    
    echo "Conversion complete!"
    """
}