params.input = "$projectDir/data"
params.outdir = "$projectDir/results"

include { VARIANT_CALLING_PIPELINE } from './workflows/workflow.nf'

workflow {
    VARIANT_CALLING_PIPELINE()
}