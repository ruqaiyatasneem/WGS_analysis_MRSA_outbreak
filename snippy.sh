#!/bin/bash

REFERENCE="st22ref-renamed.fasta"


for SAMPLE in ERR070040 ERR070044 ERR070042 ERR070043 ERR070045 ERR070046 ERR070047 ERR070033 ERR070034 ERR070036 ERR070038 ERR070048 ERR070039 ERR072246 
do
	R1="${SAMPLE}_1.fastq.gz"
	R2="${SAMPLE}_2.fastq.gz"
	OUTDIR="snippy_${SAMPLE}"

        snippy --ref $REFERENCE --R1 $R1 --R2 $R2 --outdir $OUTDIR --cpus 4
done

snippy-core --ref $REFERENCE snippy_ERR070040 snippy_ERR070042 snippy_ERR070043 snippy_ERR070045 snippy_ERR070046 snippy_ERR070033 snippy_ERR070034 snippy_ERR070036 snippy_ERR070038 snippy_ERR070048 snippy_ERR070039 snippy_ERR070047 snippy_ERR072246 snippy_ERR070044

snp-sites -vp -o core1-14isolates core.full.aln

snp-dists core1-14isolates.aln > core1-14isolates.tsv

./raxmlHPC -s core1-14isolates-snp-sites.phylip -m GTRCAT -n raxml1-14cat -p 12345 -#100 -f a -x 26812
