source ~/perl5/perlbrew/etc/bashrc

mkdir -p test

input_="test/YUHL107_HL.sort.norm2.vcf"
name="test/YUHL107_HL_vep.vcf"


## print AlphaMissense scores and predictions (default)
## ./vep -i variations.vcf --plugin AlphaMissense,file=/full/path/to/file.tsv.gz
/home/syjoo/program/ensembl-vep/vep --af --fasta /home/syjoo/.vep/homo_sapiens/106_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --af_gnomad --appris --biotype --buffer_size 500 --canonical --check_existing --distance 5000 --domains --hgvs --mane --numbers -plugin AlphaMissense,file=/home/syjoo/REF/AlphaMissense/dm_alphamissense/AlphaMissense_hg38.tsv.gz --protein --pubmed --regulatory --species homo_sapiens --symbol --transcript_version --tsl --cache --offline --input_file ${input_} --output_file ${name}

