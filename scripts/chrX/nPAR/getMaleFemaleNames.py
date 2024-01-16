import pandas as pd

# Read in metadata file with population and sex info
meta = pd.read_table("igsr_samples.tsv") 
meta = meta.set_index('Sample name')


## Get list of all the populations in 1KGP
popFile = "../make_table_pop_sizes.txt"
f = open(popFile, 'r')
lines = f.readlines()
popList = [x.strip().split()[0] for x in lines]
f.close()


# Read in header from vcf file 
for pop in popList:
  inName = "vcfHeaderIndividuals/" + pop + "_individuals.txt"
  f = open(inName, 'r')
  individuals =  f.readlines()
  f.close()
  
  # Lists to store male and female individuals per population
  males = []
  females = []
  
  # Separate out males and females 
  for i in individuals:
    i = i.strip()
    try:
      sex = meta.loc[i, "Sex"]
      if sex == 'male':
        males.append(i)
      elif sex == 'female':
        females.append(i)
      else:
        print("Individual " + i + " not coded as m or f")
    except:
      print("Individual " + i + " not found in metadata :(")
      
  # Write data to file 
  maleOutName = "maleIndividualNames/" + pop + "_males.txt"
  femaleOutName = "femaleIndividualNames/" + pop + "_females.txt"
  
  f=open(maleOutName, 'w')
  for i in males:
    f.write(i + '\n')
  f.close()
  
  f=open(femaleOutName, 'w')
  for i in females:
    f.write(i + '\n')
  f.close()
