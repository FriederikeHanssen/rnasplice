process MISO_INDEX {
    label "process_high"

    conda (params.enable_conda ? "conda-forge::python=2.7 bioconda::misopy=0.5.4" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/misopy:0.5.4--py27h9801fc8_5' :
        'quay.io/biocontainers/misopy:0.5.4--py27h9801fc8_5' }"

    input:
    path gff3

    output:
    path "index"         , emit: miso_index
    path "versions.yml"  , emit: versions

    script:
    """
    index_gff --index $gff3 index

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed "s/Python //g")
        misopy: \$(python -c "import pkg_resources; print(pkg_resources.get_distribution('misopy').version)")
    END_VERSIONS
    """
}
