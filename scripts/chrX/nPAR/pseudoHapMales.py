import pandas as pd
import random
import gzip
import sys

random.seed(37)

pop = sys.argv[1]

inNameMale = 'chrX_male_nPAR/' + pop + '_chrX_male_nPAR_masked.vcf.gz'
inNameFemale = 'chrX_female_nPAR/' + pop + '_chrX_female_nPAR_masked.vcf.gz'
outName = 'vcfBodies/' + pop + '_body.vcf'

vcf = pd.read_table(inNameMale, header = 62, delim_whitespace=True, dtype='str') 
# Reading in as string because 1. we want to concatenate rows, 2, missing gt coded as '.', so reading in 0/1 as ints results in mixed data type series 

# Get ids 
ids = vcf.columns[9:].to_list()

# Randomly reorder ids 
random.shuffle(ids)

# Initialize vcf to write output to
vcf_full = pd.read_table(inNameFemale, header = 62, delim_whitespace=True, dtype='str') 

if len(vcf.index) != len(vcf_full.index):
  print("WATCH OUT: DATA FRAMES HAVE DIFFERENT SIZES")

# Combine pairs of ids 
while len(ids) > 1:
  id1 = ids.pop()
  id2 = ids.pop()
  colName = id1 + '_' + id2
  
  vcf_full[colName] = vcf[id1] + '/' + vcf[id2]

# Write to file
vcf_full.to_csv(outName, sep='\t', index=False)
