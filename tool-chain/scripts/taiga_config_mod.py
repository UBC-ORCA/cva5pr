import fileinput
import sys
import random
#To test more parameters: create a list <parameter_name> = ["<parameter_name", "<potential value 0>", "<potential value 1>" ...]
#and add the newly created lists to params[]
USE_BRANCH_PREDICTOR = ["USE_BRANCH_PREDICTOR", "0","1"]
BRANCH_PREDICTOR_WAYS = ["BRANCH_PREDICTOR_WAYS", "2","3"]
BRANCH_TABLE_ENTRIES = ["BRANCH_TABLE_ENTRIES", "512","1024"]
RAS_DEPTH = ["RAS_DEPTH", "8", "16"]
#list of all params 
params = [USE_BRANCH_PREDICTOR,
		  BRANCH_PREDICTOR_WAYS,
		  BRANCH_TABLE_ENTRIES,
		  RAS_DEPTH]

#store all params in a dict
params_dict = {}
for index in range(len(params)):
	curr_param_list = params[index]
	params_dict[curr_param_list[0]] = curr_param_list[1:]

#iterate taiga_config
taiga_config = sys.argv[1]
params_dict_keys = [*params_dict]

with fileinput.input(files=taiga_config, inplace=True) as f:
	for line in f:
		found = False
		for curr_param in params_dict_keys:
			if curr_param in line:
				new_val = random.choice(params_dict[curr_param])
				print("\tlocalparam {} = {}; //taiga_config_mod.py\n".format(curr_param, new_val), end='');
				found = True
				break
		if found != True:
			print(line, end='')

