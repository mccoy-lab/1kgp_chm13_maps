# Read in names of populations
f = open("make_table_pop_sizes.txt", 'r')
pops = f.readlines()
f.close
pops = [l.strip().split()[0] for l in pops]
print(pops)

popSizes = []
for pop in pops:
  fname = "finalVcf/" + pop + "_chrX_nPar.vcf"
  f = open(fname, 'r')
  for l in f:
    # Find header
    if l.startswith("#CHROM"):
      # Count individuals
      l = l.strip().split()[9:]
      nIndividuals = len(l)
      
      # Count chromosomes
      nChr = 2 * nIndividuals
      
      # Get 1.5x number of chromosomes 
      nChr_big = int(1.5 * nChr)
      
      popSizes.append(" ".join([pop, str(nChr), str(nChr_big)]) + "\n")
      break

# Write to file
f = open("chrX_nPAR_make_table_pop_sizes.txt", "w")
for l in popSizes:
  f.write(l)
f.close()
