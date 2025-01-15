#!/bin/bash

# Paths
ANNOVAR_DIR="/home/syjoo/program/annovar"
HUMANDB_DIR="$ANNOVAR_DIR/humandb/humandb"
CCRE_BED="hg38_cCREs_zerobase.bed"
INPUT_VCF="YUHL_HL.sort.vcf"
OUTPUT_PREFIX1="test_YUHL_HL"
OUTPUT_PREFIX2="test2_YUHL"

# Annotation code for variants in cCRE region
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

# Annotation code for additional database annotations
echo "Annotating variants with additional databases..."
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

echo "Annotation complete!"
