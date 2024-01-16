import gzip

## Get list of all the populations in 1KGP
popFile = "../make_table_pop_sizes.txt"
f = open(popFile, 'r')
lines = f.readlines()
popList = [x.strip().split()[0] for x in lines]
f.close()

# Read in CSV header 
for pop in popList:
  inName = "../chrX/chrX_vcfs_masked/" + pop + "_chrX_masked.vcf.gz"
  f = gzip.open(inName, 'rb')
  for l in f:
    l = l.decode("utf-8")
    if l.startswith('#CHROM'):
      header = l
      break
    
  
  f.close()
  # Extract individual IDs from header
  header = header.strip().split()[9:]
  
  outName = "vcfHeaderIndividuals/" + pop + "_individuals.txt"
  f=open(outName, 'w')
  # Write to file
  for ind in header:
    f.write(ind + '\n')
  
  f.close()
