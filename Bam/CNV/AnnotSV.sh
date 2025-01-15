#!/bin/bash

# Load necessary modules
module load htslib bedtools bcftools annotsv

# Variables
INPUT_VCF="./YUHL_107.merged.vcf.gz"
ANNOTATIONS_DIR="/opt/annotsv/3.0.9/share/AnnotSV/"
GENE_LIST="/home/syjoo/REF/HHL_genelist.txt"
GENOME_BUILD="GRCh38"
LOG_FILE="AnnotSV_HL.log"

# Full annotation mode with filtering
AnnotSV \
  -SVinputFile $INPUT_VCF \
  -annotationsDir $ANNOTATIONS_DIR \
  -annotationMode full \
  -candidateGenesFile $GENE_LIST \
  -candidateGenesFiltering yes \
  -genomeBuild $GENOME_BUILD \
  -rankFiltering 3-5 \
  -svtBEDcol 5 >& $LOG_FILE &
