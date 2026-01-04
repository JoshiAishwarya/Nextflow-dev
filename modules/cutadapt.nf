/*
========================================
MODULE 2: Cutadapt Trimming
========================================
What this does:
- Takes your raw FASTQ files
- Removes adapter sequences
- Removes low quality bases
- Creates clean FASTQ files
========================================
*/

process CUTADAPT {
    // Where to save results
    publishDir "${params.output}/2_trimmed", mode: 'copy'
    
    // What comes in (input)
    input:
    tuple val(sample_id), path(reads)
    
    // What goes out (output)
    output:
    tuple val(sample_id), path("${sample_id}_trimmed_{1,2}.fastq.gz"), emit: trimmed_reads
    path("${sample_id}_cutadapt.log"), emit: log
    
    // The command to run
    script:
    """
    echo "Trimming adapters for ${sample_id}..."
    
    ${params.cutadapt_bin} \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        -q 20 \
        -m 20 \
        -o ${sample_id}_trimmed_1.fastq.gz \
        -p ${sample_id}_trimmed_2.fastq.gz \
        ${reads[0]} ${reads[1]} \
        > ${sample_id}_cutadapt.log
    
    echo "Trimming complete!"
    """
}

/*
Explanation of Cutadapt parameters:
-a = adapter for read 1 (forward)
-A = adapter for read 2 (reverse)
-q 20 = trim bases with quality < 20
-m 20 = discard reads shorter than 20bp
-o = output file 1
-p = output file 2
*/