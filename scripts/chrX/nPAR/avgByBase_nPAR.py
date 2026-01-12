import sys
import numpy as np

# get population names and sizes 
f = open("chrX_nPAR_make_table_pop_sizes.txt", "r")
pops = []
popSizes = []
for line in f: 
  pops.append(line.strip().split()[0])
  popSizes.append(int(line.strip().split()[1]))

popSizes = [x/sum(popSizes) for x in popSizes]

fullChrAllPops = []

for pop in pops:
  print(pop)
  fname = 'pyrho_1kgp_chm13_unphased/chrX_nPAR/opt_params_toAvg/' + pop + '_chrX_nPAR.tsv'
  chrMap = np.genfromtxt(fname, skip_header = 1, usecols = [1,2,3])
    
  chrLength = int(np.max(chrMap[:, 1]))
  
  fullChromosome = np.zeros(chrLength)
  
  for i in chrMap:
    startCoord = int(i[0])
    stopCoord = int(i[1]) + 1
    recRate = i[2]
    
    fullChromosome[startCoord:stopCoord] = recRate
    
  fullChrAllPops.append(fullChromosome)
 
arrayLengths = [len(x) for x in fullChrAllPops] 
maxLen = max(arrayLengths)

for i in range(len(fullChrAllPops)):
  toPad = maxLen - len(fullChrAllPops[i])
  fullChrAllPops[i] = np.pad(fullChrAllPops[i], (0, toPad), 'constant')

fullChrAllPops_NP = np.stack(fullChrAllPops, axis=1)

avgRec = np.average(fullChrAllPops_NP, axis = 1, weights = popSizes)

idxRetain = [0]
stopRetain = []
avgRecRetain = [avgRec[0]]
for i in range(1, len(avgRec)):
  if avgRec[i] != avgRec[i-1]:
    idxRetain.append(i)
    stopRetain.append(i-1)
    avgRecRetain.append(avgRec[i])
    
stopRetain.append(i)

filteredMap = np.stack([idxRetain, stopRetain, avgRecRetain], axis=1)

outName = 'averagedByBase/chrX_nPAR.txt'
f = open(outName, 'w')

for i in range(filteredMap.shape[0]):
  start = int(filteredMap[i, 0])
  stop = int(filteredMap[i, 1])
  rr = filteredMap[i, 2]
  outString ='\t'.join([str(start), str(stop), str(rr)]) + '\n'
  f.write(outString)
