import os,sys,string,glob

fp = glob.glob('*_dedup.bam')
CHR = [str(k) for k in range(1,23)]
CHR.append('X')
CHR.append('Y')

for fname in fp:
	Bam = string.split(fname,'.bam')[0]
    print('Extract read mapping for '+Bam)
	os.system('/home/program/CNVnator/cnvnator -root '+Bam+'.root -tree '+Bam+'.bam -chrom '+" ".join(map(lambda z:"chr"+z, CHR)))
	for bin_size in [150]:
       		bin_size = str(bin_size)
       		print('Generate histogram for '+Bam)
       		os.system('/home/program/CNVnator/cnvnator -root '+Bam+'.root -his '+bin_size+' -d /home/syjoo/REF/Human/hg38/chromosomes/')
       		print('Calculate statistics for '+Bam)
       		os.system('/home/program/CNVnator/cnvnator -root '+Bam+'.root -stat '+bin_size)
       		print('Partition for '+Bam)
       		os.system('/home/program/CNVnator/cnvnator -root '+Bam+'.root  -partition '+bin_size)
       		print('Call CNVs for '+Bam)
       		os.system('/home/program/CNVnator/cnvnator -root '+Bam+'.root -call 150 > '+Bam+'.cnv')

root = glob.glob('*.root')

for i in root:
	sn = string.split(i,'.root')[0]
	os.system('bgzip '+sn+'.vcf')
	os.system('tabix '+sn+'.vcf.gz')

os.system('bcftools merge *.vcf.gz -Oz -o YUHL_107.merged.vcf.gz')

