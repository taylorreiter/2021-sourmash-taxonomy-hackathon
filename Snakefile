
#LIBRARIES = ['HSMA33MX']
LIBRARIES = ['PSM7J177','PSM6XBW3', 'CSM67UEW_TR']

rule all:
    input:
        expand("outputs/gather/{library}_gather_x_gtdbrs202_reps_k31.csv", library = LIBRARIES),
        expand("outputs/gather/{library}_gather_x_gtdbrs202_k31.csv", library = LIBRARIES),
        expand("outputs/gather/{library}_gather_x_gtdbrs202_genbank_euks_k31.csv", library = LIBRARIES),
        expand("outputs/gather/{library}_gather_x_genbank_k31.csv", library = LIBRARIES)

rule download_reads:
    output:
        r1="inputs/raw/{library}_R1.fq.gz",
        r2="inputs/raw/{library}_R2.fq.gz"
    shell:'''
    wget -O {output.r1} ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR595/007/SRR5950647/SRR5950647_1.fastq.gz
    wget -O {output.r2} ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR595/007/SRR5950647/SRR5950647_2.fastq.gz    
    '''

rule fastp:
    input: 
        r1 = "inputs/raw/{library}_R1.fq.gz",
        r2 = "inputs/raw/{library}_R2.fq.gz"
    output: 
        r1 = 'outputs/fastp/{library}_R1.fastp.fq.gz',
        r2 = 'outputs/fastp/{library}_R2.fastp.fq.gz',
        json = 'outputs/fastp/{library}.json'
    conda: 'envs/fastp.yml'
    shell:'''
    fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2} -q 4 -j {output.json} -l 31 -c
    '''

rule download_human_db:
    output: "inputs/host/hg19_main_mask_ribo_animal_allplant_allfungus.fa.gz"
    shell:'''
    wget -O {output} https://osf.io/84d59/download
    '''

rule remove_host:
# http://seqanswers.com/forums/archive/index.php/t-42552.html
# https://drive.google.com/file/d/0B3llHR93L14wd0pSSnFULUlhcUk/edit?usp=sharing
    output:
        r1 = 'outputs/bbduk/{library}_R1.nohost.fq.gz',
        r2 = 'outputs/bbduk/{library}_R2.nohost.fq.gz',
        human_r1='outputs/bbduk/{library}_R1.human.fq.gz',
        human_r2='outputs/bbduk/{library}_R2.human.fq.gz'
    input: 
        r1 = 'outputs/fastp/{library}_R1.fastp.fq.gz',
        r2 = 'outputs/fastp/{library}_R2.fastp.fq.gz',
        human='inputs/host/hg19_main_mask_ribo_animal_allplant_allfungus.fa.gz'
    conda: 'envs/bbduk.yml'
    shell:'''
    bbduk.sh -Xmx64g t=3 in={input.r1} in2={input.r2} out={output.r1} out2={output.r2} outm={output.human_r1} outm2={output.human_r2} k=31 ref={input.human}
    '''

rule kmer_trim_reads:
    input: 
        'outputs/bbduk/{library}_R1.nohost.fq.gz',
        'outputs/bbduk/{library}_R2.nohost.fq.gz'
    output: "outputs/abundtrim/{library}.abundtrim.fq.gz"
    conda: 'envs/khmer.yml'
    shell:'''
    interleave-reads.py {input} | trim-low-abund.py --gzip -C 3 -Z 18 -M 60e9 -V - -o {output}
    '''

rule compute_signature:
    input: "outputs/abundtrim/{library}.abundtrim.fq.gz"
    output: "outputs/sigs/{library}.sig"
    conda: 'envs/sourmash.yml'
    shell:'''
    sourmash compute -k 21,31,51 --scaled 2000 --track-abundance --name {wildcards.library} -o {output} {input}
    '''

rule gather_gtdb_rs202:
    input:
        sig="outputs/sigs/{library}.sig",
        db1="/group/ctbrowngrp/gtdb/databases/ctb/gtdb-rs202.genomic.k31.sbt.zip",
    output: 
        csv="outputs/gather/{library}_gather_x_gtdbrs202_k31.csv"
    conda: 'envs/sourmash.yml'
    resources:
        mem_mb = 128000
    threads: 1
    shell:'''
    sourmash gather -o {output.csv} --scaled 2000 -k 31 {input.sig} {input.db1}
    '''

rule gather_gtdb_rs202_reps:
    input:
        sig="outputs/sigs/{library}.sig",
        db1="/group/ctbrowngrp/gtdb/databases/ctb/gtdb-rs202.genomic-reps.k31.sbt.zip",
    output: 
        csv="outputs/gather/{library}_gather_x_gtdbrs202_reps_k31.csv"
    conda: 'envs/sourmash.yml'
    resources:
        mem_mb = 128000
    threads: 1
    shell:'''
    sourmash gather -o {output.csv} --scaled 2000 -k 31 {input.sig} {input.db1}
    '''

rule gather_genbank:
    input:
        sig="outputs/sigs/{library}.sig",
        db1="/home/irber/sourmash_databases/outputs/sbt/genbank-bacteria-x1e6-k31.sbt.zip",
        db2="/home/irber/sourmash_databases/outputs/sbt/genbank-archaea-x1e6-k31.sbt.zip",
        db3="/home/irber/sourmash_databases/outputs/sbt/genbank-viral-x1e6-k31.sbt.zip",
        db4="/home/irber/sourmash_databases/outputs/sbt/genbank-fungi-x1e6-k31.sbt.zip",
        db5="/home/irber/sourmash_databases/outputs/sbt/genbank-protozoa-x1e6-k31.sbt.zip",
    output:
        csv="outputs/gather/{library}_gather_x_genbank_k31.csv"
    conda: 'envs/sourmash.yml'
    resources:
        mem_mb = 128000
    threads: 1
    shell:'''
    sourmash gather -o {output.csv} --scaled 2000 -k 31 {input.sig} {input.db1} {input.db2} {input.db3} {input.db4} {input.db5}
    '''

rule gather_gtdb_rs202_genbank_euks:
    input:
        sig="outputs/sigs/{library}.sig",
        db1="/group/ctbrowngrp/gtdb/databases/ctb/gtdb-rs202.genomic.k31.sbt.zip",
        db2="/home/irber/sourmash_databases/outputs/sbt/genbank-viral-x1e6-k31.sbt.zip",
        db3="/home/irber/sourmash_databases/outputs/sbt/genbank-fungi-x1e6-k31.sbt.zip",
        db4="/home/irber/sourmash_databases/outputs/sbt/genbank-protozoa-x1e6-k31.sbt.zip",
    output: 
        csv="outputs/gather/{library}_gather_x_gtdbrs202_genbank_euks_k31.csv"
    conda: 'envs/sourmash.yml'
    resources:
        mem_mb = 128000
    threads: 1
    shell:'''
    sourmash gather -o {output.csv} --scaled 2000 -k 31 {input.sig} {input.db1} {input.db2} {input.db3} {input.db4}
    '''
