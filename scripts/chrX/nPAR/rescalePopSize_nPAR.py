import pandas as pd 

# Read in names of populations
f = open("make_table_pop_sizes.txt", 'r')
pops = f.readlines()
f.close
pops = [l.strip().split()[0] for l in pops]


for pop in pops:
  fname = 'smcpp_popsizes_1kg/' +  pop + '_pop_sizes.csv'
  smcTable = pd.read_csv(fname)
  smcTable.loc[:, 'y'] = 0.75 * smcTable.loc[:, 'y']
  outName = 'smcpp_popsizes_1kg_nPAR/' +  pop + '_pop_sizes_nPAR.csv'
  
  smcTable.to_csv(outName, index=False)
