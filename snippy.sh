#!/bin/bash

REFERENCE="st22ref-renamed.fasta"

for SAMPLE in ERR070040 ERR070041 ERR070042 ERR070043 
do
	R1="${SAMPLE}_1.fastq.gz"
	R2="${SAMPLE}_2.fastq.gz"
	OUTDIR="snippy_${SAMPLE}"

        snippy --ref $REFERENCE --R1 $R1 --R2 $R2 --outdir $OUTDIR --cpus 4

snippy-core --ref st22ref-renamed.fasta snippy1-246 snippy3-42 snippy4-43  snippy5-44 snippy6-45 snippy7-46 snippy8-33 snippy9-34 snippy10-36 snippy11-38 snippy12-48 snippy13-39 snippy14-40 snippy15-47 snippy16-54

snp-sites -vp -o core1-14isolates core.full.aln

snp-dists core1-14isolates.aln > core1-14isolates.tsv

./raxmlHPC -s core1-14isolates-snp-sites.phylip -m GTRCAT -n raxml1-14cat -p 12345 -#100 -f a -x 26812
