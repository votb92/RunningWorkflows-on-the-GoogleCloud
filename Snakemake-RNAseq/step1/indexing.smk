#This rule will build index files from a reference genome
rule indexing:
    input:
        "../data/reference.fa"
    output:
        touch('index.done')
    shell:
        """
        mkdir reference
        hisat2-build {input} index
        mv index.* reference/
        """
