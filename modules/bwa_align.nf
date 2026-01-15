process BWA_ALIGN {
    publishDir "${params.output}/4_alignment", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    path reference_files   // this is now a LIST of files

    output:
    tuple val(sample_id), path("${sample_id}.sam"), emit: sam

    script:
    """
    echo "Aligning ${sample_id} to reference genome..."

    # Select the FASTA file from the list
    REF_FA=\$(printf "%s\n" ${reference_files} | grep '\\.fa\$')

    bwa mem -t ${task.cpus} \$REF_FA ${reads[0]} ${reads[1]} > ${sample_id}.sam

    echo "Alignment complete!"
    """
}
