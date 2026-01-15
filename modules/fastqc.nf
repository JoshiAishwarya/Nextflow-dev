process FASTQC {

    publishDir "${params.output}/${stage}", mode: 'copy'
    

    input:
    tuple val(sample_id), path(reads)
    val(stage)  
    

    output:
    tuple val(sample_id), path("*.{html,zip}"), emit: reports
    tuple val(sample_id), path(reads), emit: reads
    

    script:
    """
    echo "Running FastQC on ${stage} reads for ${sample_id}..."
    ${params.fastqc_bin} -t 2 ${reads[0]} ${reads[1]}
    echo "FastQC complete!"
    """
}