#!/bin/bash

# Paths
ANNOVAR_DIR="/home/syjoo/program/annovar"
HUMANDB_DIR="$ANNOVAR_DIR/humandb/humandb"
CCRE_BED="hg38_cCREs_zerobase.bed"

# Input files
INPUT_VCF="YUHL_HL.sort.vcf"
MITO_VCF="merged.Mito.vcf"

# Output prefixes
OUTPUT_PREFIX1="test_YUHL_HL"
OUTPUT_PREFIX2="test2_YUHL"
MITO_OUTPUT="merged.Mito"

# Annotate variants for cCRE regions
echo "Annotating variants for cCRE regions..."
perl $ANNOVAR_DIR/table_annovar.pl $INPUT_VCF $HUMANDB_DIR \
    -buildver hg38 \
    -out $OUTPUT_PREFIX1 \
    -remove \
    -otherinfo \
    -protocol bed \
    -operation r \
    -bedfile $CCRE_BED \
    -nastring . \
    -arg '-colsWanted all' \
    -vcfinput \
    -polish

# Additional database annotation for cCRE output
echo "Annotating cCRE output with additional databases..."
perl $ANNOVAR_DIR/table_annovar.pl ${OUTPUT_PREFIX1}.hg38_multianno.vcf $HUMANDB_DIR \
    -buildver hg38 \
    -out $OUTPUT_PREFIX2 \
    -remove \
    -otherinfo \
    -protocol refGene,exac03,gnomad30_genome,avsnp147,dbnsfp33a,revel,clinvar_20220320 \
    -operation g,f,f,f,f,f,f \
    -nastring . \
    -vcfinput \
    -polish

# Annotate mitochondrial variants
echo "Annotating mitochondrial variants..."
perl $ANNOVAR_DIR/table_annovar.pl $MITO_VCF $HUMANDB_DIR \
    -buildver hg38 \
    -out $MITO_OUTPUT \
    -remove \
    -otherinfo \
    -protocol "Mitomapdisease" \
    -operation "f" \
    -nastring . \
    -vcfinput \
    -polish

echo "All annotation tasks completed!"
