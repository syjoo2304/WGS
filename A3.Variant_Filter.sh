#!/bin/bash

# Variables
si="macrogen_64_sort.g.vcf"
sn=$(echo "$si" | sed 's/.g.vcf//')

# Paths
GATK_PATH="/home/hykim/program/gatk-4.1.9.0/gatk-package-4.1.9.0-local.jar"
REFERENCE="/home/hykim/REF/Human/hg38/hg38.fa"
VQSR_PATH="/home/syjoo/test/VQSR/LIFTOVER"

# Step 1: Variant Recalibration for SNPs
OUTPUT=${sn}'macrogen_64_sort.norm.vcf'
OUTPUT2='macrogen_64_sort.norm2.vcf'

java -Xmx64g -jar $GATK_PATH LeftAlignAndTrimVariants \
   -R ${REF} \
   -V ${si} \
   -O ${sn}.norm.vcf \
   --split-multi-allelics

java -Xmx64g -jar /home/program/gatk-4.0.11.0/gatk-package-4.0.11.0-local.jar SelectVariants \
    -R ${REF} \
    -V ${sn}.norm.vcf \
    --exclude-non-variants TRUE \
    -O ${sn}.norm2.vcf


java -Xmx128g -jar $GATK_PATH VariantRecalibrator \
    -R $REFERENCE \
    -V ${sn}.norm2.vcf \
    --resource:hapmap,known=false,training=true,truth=true,prior=15.0 $VQSR_PATH/hapmap_3.3.hg38.vcf \
    --resource:omni,known=false,training=true,truth=false,prior=12.0 $VQSR_PATH/1000G_omni2.5.hg38.vcf \
    --resource:1000G,known=false,training=true,truth=false,prior=10.0 $VQSR_PATH/1000G_phase1.snps.high_confidnece.hg38.vcf \
    --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $VQSR_PATH/Homo_sapiens_assembly19.dbsnp138.hg38.vcf \
    -an QD -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
    -mode SNP \
    -O ${sn}_SNP.recal \
    --tranches-file ${sn}_SNP.tranches \
    --rscript-file ${sn}_SNP.plots.R

# Step 2: Apply VQSR for SNPs
java -Xmx128g -jar $GATK_PATH ApplyVQSR \
    -R $REFERENCE \
    -V $si \
    -O ${sn}_select_snp.vcf \
    --truth-sensitivity-filter-level 99.9 \
    --tranches-file ${sn}_SNP.tranches \
    --recal-file ${sn}_SNP.recal \
    --exclude-filtered TRUE \
    -mode SNP

# Step 3: Variant Recalibration for INDELs
java -Xmx128g -jar $GATK_PATH VariantRecalibrator \
    -R $REFERENCE \
    -V ${sn}_select_snp.vcf \
    --resource:mills,known=false,training=true,truth=true,prior=12.0 $VQSR_PATH/Mills_and_1000G_gold_standard.indels.hg38.sites.vcf \
    --resource:dbsnp,known=false,training=true,truth=false,prior=2.0 $VQSR_PATH/Homo_sapiens_assembly19.dbsnp138.hg38.vcf \
    -an QD -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
    --max-gaussians 4 \
    -mode INDEL \
    -O ${sn}_INDEL.recal \
    --tranches-file ${sn}_INDEL.tranches \
    -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 95.0 -tranche 90.0 \
    --rscript-file ${sn}_INDEL.plots.R

# Step 4: Apply VQSR for INDELs
java -Xmx128g -jar $GATK_PATH ApplyVQSR \
    -R $REFERENCE \
    -V ${sn}_select_snp.vcf \
    -O ${sn}_select_snp_indel.vcf \
    -ts-filter-level 99.0 \
    --tranches-file ${sn}_INDEL.tranches \
    --recal-file ${sn}_INDEL.recal \
    -mode INDEL \
    --exclude-filtered TRUE
