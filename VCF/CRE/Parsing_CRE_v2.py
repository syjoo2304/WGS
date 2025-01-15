import os,sys,string

fp=open('YUHL107_HL_2.hg38_multianno.vcf','r')
fpout=open('YUHL107_HL_3.filtered.txt','w')

for line in fp:
	line_temp=line[:-1].split('\t')
	if line.startswith('##'): continue
	elif line.startswith('#CHROM'):
		SI=line_temp[9:]
		fpout.write('POS'+'\t'+'Sample+ID'+'\t'+'Sample+hom+ID'+'\t'+'cCRE'+'\t'+'Gene+Name'+'\t'+'CADD_phred'+'\t'+'Func.refGene'+'\t'+'Exonic.refGene'+'\t'+'AAChange.refGene'+'\t'+'\t'.join(line_temp)+'\n')
	else:
		co,cnt=0,0
		CRE=string.split(line_temp[7],';')	#'aachange=.', 'homoplasmy=.', 'heteroplasmy=.', 'disease=.', 'status=.', 'pubmed_ids=.', 'gbcnt=.', 'gbfreq=.', 'ALLELE_END']
		POS=':'.join(line_temp[:5])
		REF,ALT=line_temp[3],line_temp[4]
		
		if not REF == '*' and not ALT == '*':
			for c in CRE:
				sn = string.split(c,'=')
				if sn[0] == 'bed':
					CRE = sn[1] 
				if sn[0] == 'AC' and co == 0 :
					co+=1
					AC_internal = sn[1]
				if sn[0] == 'AF':
					cnt+=1
					if cnt == 2:
						AF = sn[1]
				if sn[0] == 'AF_eas':
					AF_eas = sn[1]
				if sn[0] == 'Gene.refGene':
					Gene = sn[1]
				if sn[0] == 'CADD_phred':
					CADD = sn[1]
				if sn[0] == 'Func.refGene':#ExonicFunc.refGene=.;AAChange.refGene=.
					Func = sn[1]
				if sn[0] == 'ExonicFunc.refGene':
					Exonic = sn[1]
				if sn[0] == 'AAChange.refGene':
					AA = sn[1]
			if CRE != '.': # and 'CTCF-bound' in CRE:
				if  AF == '.' or float(AF) <= 0.01:
					if AF_eas == '.' or float(AF_eas) <= 0.01:
						GT=line_temp[9:]
						sample_positive=[]
						sample_pos_hom=[]
						for j in range(0,len(GT)):
							gt = string.split(GT[j],':')[0]
							if gt == '0/1' or gt == '1/1':
								sample_positive.append(SI[j])
							if gt == '1/1':
								sample_pos_hom.append(SI[j])
				
						if not sample_pos_hom:
							sample_pos_hom.append('.')
						if sample_positive:
							fpout.write(POS+'\t'+','.join(sample_positive)+'\t'+','.join(sample_pos_hom)+'\t'+CRE+'\t'+Gene+'\t'+CADD+'\t'+Func+'\t'+Exonic+'\t'+AA+'\t'+'\t'.join(line_temp)+'\n')
							if Gene == 'TRIOBP' and Exonic == 'synonymous_SNV': print line

fpout.close()
