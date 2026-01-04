/*
========================================
MODULE 1: FastQC on Raw Reads
========================================
What this does:
- Takes your original FASTQ files
- Checks their quality
- Creates HTML reports
========================================
*/

process FASTQC_RAW {
    // Where to save results
    publishDir "${params.output}/1_fastqc_raw", mode: 'copy'
    
    // What comes in (input)
    input:
    tuple val(sample_id), path(reads)
    
    // What goes out (output)
    output:
    tuple val(sample_id), path("*.{html,zip}"), emit: reports
    tuple val(sample_id), path(reads), emit: reads
    
    // The command to run
    script:
    """
    echo "Running FastQC on raw reads for ${sample_id}..."
    ${params.fastqc_bin} -t 2 ${reads[0]} ${reads[1]}
    echo "FastQC on raw reads complete!"
    """
}