process CUTADAPT {
    publishDir "${params.output}/2_trimmed", mode: 'copy'
    
    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("${sample_id}_trimmed_{1,2}.fastq.gz"), emit: trimmed_reads
    path("${sample_id}_cutadapt.log"), emit: log
    
    script:
    """
    echo "Trimming adapters for ${sample_id}..."
    
    ${params.cutadapt_bin} \
        -a ${params.adapter_forward} \
        -A ${params.adapter_reverse} \
        -q ${params.min_quality} \
        -m ${params.min_length} \
        -o ${sample_id}_trimmed_1.fastq.gz \
        -p ${sample_id}_trimmed_2.fastq.gz \
        ${reads[0]} ${reads[1]} \
        > ${sample_id}_cutadapt.log
    
    echo "Trimming complete!"
    """
}