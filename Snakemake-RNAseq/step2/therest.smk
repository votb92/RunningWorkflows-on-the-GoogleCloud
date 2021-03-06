# This rule will align the reads to the reference genome, results in a sam file with alignment datas.
rule hisat2:
    input:
        r1 = '../data/{sample}_1.fq',
        r2 = '../data/{sample}_2.fq'
    output:
        r1 = '{sample}.cutadapt.sam'
    shell: """
        hisat2  -x ../step1/reference/index --dta  --rna-strandness RF -1 {input.r1}  -2 {input.r2} -S {output.r1}
    """

# This rule will create a compressed binary data (Bam) from Sam file using samtools
rule create_bams:
    input:
        "{sample}.cutadapt.sam"
    output:
        "{sample}.cutadapt.bam"
    shell:
        "samtools view -bh {input} | samtools sort - -o {output}; samtools index {output}"

# This rule will quanitify the reads depth from the Bam file and produce transcript
rule transcript:
    input:
        "{sample}.cutadapt.bam"
    output:
        r1 = '{sample}_transcript.gtf',
        r2 = '{sample}.tsv',
        r3 = '{sample}_ref.gtf'
    shell:
        "stringtie -G ../data/ggal.gtf --rf  -e -B -o {output.r1} -A {output.r2} -C {output.r3} --rf {input}"
