import numpy as np
import pandas as pd
import os 

pops = list(set([x.split('_')[0] for x in os.listdir("../pyrho_1kgp_chm13_unphased_no_mask/opt_params_scaled_deCODE")]))

for pop in pops:
	print(pop)
	for thresh in [5, 10, 50, 100]:
		# Data import
		in_name = "hotspots/hg38/" + str(thresh) + "x/" + pop + "_" + str(thresh) + "x_hotspots.csv"
		in_file = pd.read_csv(in_name)

		in_file['Chromosome'] = in_file['Chromosome'].astype(str)
		in_file['Start'] = in_file['Start'].astype(int)
		in_file['End'] = in_file['End'].astype(int)

		# lists to store output
		chromosomes = []
		start_coords = []
		end_coords = []
		rec_rates = []


		for i in range(in_file.shape[0]):
			if i == 0:
				chromosomes.append(in_file['Chromosome'][i])
				start_coords.append(in_file['Start'][i])
				end_coords.append(in_file['End'][i])
				rec_rates.append(in_file['Rec.Rate'][i])

			else:
				if in_file['Start'][i] == end_coords[-1]:
					end_coords[-1] = in_file['End'][i]
					rec_rates[-1] = max(rec_rates[-1], in_file['Rec.Rate'][i])
				else:
					chromosomes.append(in_file['Chromosome'][i])
					start_coords.append(in_file['Start'][i])
					end_coords.append(in_file['End'][i])
					rec_rates.append(in_file['Rec.Rate'][i])


		out_df = pd.DataFrame({'Chromosome': chromosomes, 
			'Start': start_coords, 
			'End': end_coords, 
			'Rec.Rate': rec_rates}) 
				
		out_name = "hotspots_compact/hg38/" + str(thresh) + "x/" + pop + "_" + str(thresh) + "x_hotspots_compact.bed"
		out_df.to_csv(out_name, index = False, sep = "\t", header = False)