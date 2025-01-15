#!/bin/bash

# Path to BAM files
BAM_PATH="/home/DATA/YUHL/WGS/FASTQ/WGS_11/BAM_11/"
REFERENCE="/home/syjoo/REF/Human/hg38/hg38/Homo_sapiens_assembly38.fasta"
MANTA_CONFIG="/home/syjoo/program/manta-1.6.0.centos6_x86_64/bin/configManta.py"
JOB_THREADS=4

# Create an array of BAM files
BAM_FILES=($(ls $BAM_PATH*_dedup.bam))

# Initialize a sample list
SAMPLE_LIST=()

# Create symlinks and populate the sample list
for BAM_FILE in "${BAM_FILES[@]}"; do
    BASENAME=$(basename "$BAM_FILE" "_dedup.bam")
    ln -s "${BAM_PATH}${BASENAME}_dedup.bam" .
    ln -s "${BAM_PATH}${BASENAME}_dedup.bai" .
    SAMPLE_LIST+=("$BASENAME")
done

# Run configManta.py for each sample
TOTAL_SAMPLES=${#SAMPLE_LIST[@]}
COUNT=0
for SAMPLE in "${SAMPLE_LIST[@]}"; do
    COUNT=$((COUNT + 1))
    echo "$COUNT of $TOTAL_SAMPLES: Running configManta.py for $SAMPLE"
    python "$MANTA_CONFIG" \
        --bam "${SAMPLE}_dedup.bam" \
        --runDir "./${SAMPLE}" \
        --reference "$REFERENCE"
    echo "First step complete for $SAMPLE!"
done

# Run Manta workflows for each sample
COUNT=0
for SAMPLE in "${SAMPLE_LIST[@]}"; do
    COUNT=$((COUNT + 1))
    echo "$COUNT of $TOTAL_SAMPLES: Running Manta workflow for $SAMPLE"
    python "./${SAMPLE}/runWorkflow.py" -j "$JOB_THREADS"
    echo "Last step complete for $SAMPLE!"
done

echo "All samples processed successfully!"
