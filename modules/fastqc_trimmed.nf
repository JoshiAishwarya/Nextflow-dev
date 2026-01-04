/*
========================================
MODULE 3: FastQC on Trimmed Reads
========================================
What this does:
- Takes your cleaned FASTQ files
- Checks their quality
- Creates HTML reports
- Compare with Module 1 to see improvement!
========================================
*/

process FASTQC_TRIMMED {
    // Where to save results
    publishDir "${params.output}/3_fastqc_trimmed", mode: 'copy'
    
    // What comes in (input)
    input:
    tuple val(sample_id), path(reads)
    
    // What goes out (output)
    output:
    tuple val(sample_id), path("*.{html,zip}"), emit: reports
    
    // The command to run
    script:
    """
    echo "Running FastQC on trimmed reads for ${sample_id}..."
    ${params.fastqc_bin} -t 2 ${reads[0]} ${reads[1]}
    echo "FastQC on trimmed reads complete!"
    """
}