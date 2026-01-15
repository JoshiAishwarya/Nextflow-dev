process SORT_BAM {
    publishDir "${params.output}/6_sorted", mode: 'copy'
    
    input:
    tuple val(sample_id), path(bam)
    
    output:
    tuple val(sample_id), path("${sample_id}_sorted.bam"), emit: sorted_bam
    
    script:
    """
    echo "Sorting BAM file for ${sample_id}..."
    
    ${params.samtools_bin} sort -o ${sample_id}_sorted.bam ${bam}

    
    echo "Sorting complete!"
    """
}