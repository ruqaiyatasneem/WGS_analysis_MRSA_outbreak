#!/bin/bash

# index files
samtools faidx st22ref.fasta

# ref dict
REF="st22ref.fasta"

gatk CreateSequenceDictionary -R $REF -O ${REF%.fasta}.dict

# align reads

bwa index $REF
SAMPLES=("ERR070040" "ERR070033" "ERR070034" "ERR070036" "ERR070039" "ERR070042" "ERR070045" "ERR070042" "ERR070043" "ERR070044" "ERR070046" "ERR070047" "ERR070048" "ERR072246")

# Loop
for SAMPLE in "${SAMPLES[@]}"
do
	# input files
	READ1="${SAMPLE}_1.fastq.gz
	READ2="${SAMPLE}_2.fastq.gz

        bwa mem -R "@RG\tID:$SAMPLE\tLB:$SAMPLE\tPL:ILLUMINA\tPM:MISEQ\tSM:$SAMPLE" $REF $READ1 $READ2 > ${SAMPLE}_aligned.sam 

        gatk MarkDuplicatesSpark -I ${SAMPLE}_aligned.sam -O ${SAMPLE}_sorted_dedup_reads.bam

       # collect alignment and insert size metrics
        gatk CollectAlignmentSummaryMetrics -R $REF -I ${SAMPLE}_sorted_dedup_reads.bam -O ${SAMPLE}_insertmetrics.txt 
        gatk CollectInsertSizeMetrics -I ${SAMPLE}_sorted_dedup_reads.bam -O ${SAMPLE}_insertmetrics.txt -H ${SAMPLE}_insert_size_histogram.pdf

      # variant caling
        gatk HaplotypeCaller  -R $REF -I ${SAMPLE}_sorted_dedup_reads.bam -O ${SAMPLE}_raw-variants_snp.vcf --sample-ploidy 1

      # extract SNPs
        gatk SelectVariants -R $REF -V ${SAMPLE}_raw_variants.vcf --select-type SNP -O ${SAMPLE}_raw_variants-snp.vcf

      # filter snps
        gatk  VariantFiltration \
	        -R $REF \
		-V ${SAMPLE}_raw_variants-snp.vcf \
	        -O ${SAMPLE}_filtered_variants-snp.vcf \
                -filter-name "QUAL50" -filter "QUAL < 50.0" \
		-filter-name "MQ30" -filter "MQ < 30.0" \
	       	-filter-name "AF_filter" -filter "AF != 0.0 && AF != 1.0" \
	        -filter-name "DP4" -filter "DP < 4.0" \
	        -filter-name "QD2"  -filter "QD < 2.0" \
                -filter-name "SOR3" -filter "SOR > 3.0" \
	       	-filter-name "FS60" -filter "FS > 60.0" \

      # exclude
       gatk SelectVariants --exclude-filtered -V ${SAMPLE}_filtered_variants-snp.vcf -O ${SAMPLE}_analysis-ready.vcf
       echo "Pipeline completed for sample: $SAMPLE"
done
