import statistics
import re
import sys
import os
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
pd.options.display.max_columns = None
# pd.options.display.width = None
presentation_template = dict(
    layout=go.Layout(
		font = dict(family="Source Sans Pro", size=12, color='#000000'),
		title_font=dict(size=24),
		colorway=['#ed7162', '#f5bd54', '#e9ce15', '#b8d018', '#33c879', '#71a5bf', '#7d81b5', '#c16fc1', '#d698bd']
	)
)


if ('TAIGA_PROJECT_ROOT' not in os.environ) :
	print ('Please set TAIGA_PROJECT_ROOT for logfile locations.')
	exit(-1)

root_dir = os.environ.get('TAIGA_PROJECT_ROOT')

reference_dir = root_dir + '/logs/verilator_ref/embench'
benchmarks_dir = root_dir + '/logs/verilator/embench'

benchmarks = [ \
 'aha-mont64', \
 'crc32', \
 'cubic', \
 'edn', \
 'huffbench', \
 'matmult-int', \
 'minver', \
 'nbody', \
 'nettle-aes', \
 'nettle-sha256', \
 'nsichneu', \
 'picojpeg', \
 'qrduino', \
 'sglib-combined', \
 'slre', \
 'st', \
 'statemate', \
 'ud', \
 'wikisort', \
 ]

# Organized as:
# benchmark     stat1   stat2         ...     statN
# aha-mont64   2389   723489     ...      23237
def generate_graph_data(directory):
	#Parse all benchmark logs.  Find any line with a ':' character and
	#save the key, value pair for that line
	graph_data = []
	for benchmark in benchmarks:
		benchmark_data = {}
		benchmark_data['benchmark'] = benchmark
		with open(directory + '/' + benchmark + '.log', 'r') as benchmark_log:
		    for line in benchmark_log:
		        line = line.strip()
		        data_line = line.split(':')
		        if (len(data_line) == 2) :
		            if ((data_line[1].strip()).isnumeric()) :
		                benchmark_data[data_line[0].strip()] = int(data_line[1].strip())
		graph_data.append(benchmark_data)
	ipc_data = []
	for entries in graph_data:
		ipc_data.append(entries['IPCx1M'])
	 
	# meanIPC = statistics.mean(ipc_data)
	# geomeanIPC = statistics.geometric_mean(ipc_data)

	# benchmark_data = {}
	# benchmark_data['benchmark'] = 'mean'
	# benchmark_data['IPCx1M'] = meanIPC
	# graph_data.append(benchmark_data)

	# benchmark_data = {}
	# benchmark_data['benchmark'] = 'geomean'
	# benchmark_data['IPCx1M'] = geomeanIPC
	# graph_data.append(benchmark_data)
	return pd.DataFrame(graph_data)

# ref_graph_data_frame = generate_graph_data(reference_dir)#pd.DataFrame(graph_data)
graph_data_frame = generate_graph_data(benchmarks_dir)#pd.DataFrame(graph_data)
graph_data_frame.index = benchmarks
print(graph_data_frame.drop(['benchmark'],axis=1))

# print (graph_data_frame.melt(id_vars="benchmark"))
#fig = px.bar(graph_data_frame.melt(id_vars="benchmark"), x='benchmark', color="variable", y='value', barmode='group')
#fig.show()

#Stall breakdown normalized to instructions executed
# stall_stats = ['operand_stall', 'unit_stall', 'no_id_stall', 'no_instruction_stall', 'other_stall']
# stall_data = graph_data_frame[['benchmark'] + stall_stats]
# instr_counts = graph_data_frame[['benchmark', 'instruction_issued_dec']]
# stalls_per_instruction = stall_data
# for stall_stat in stall_stats:
# 	stalls_per_instruction[stall_stat] /= instr_counts['instruction_issued_dec']
# fig = px.bar(stalls_per_instruction.melt(id_vars="benchmark"), x='benchmark', color="variable", y='value', barmode='stack')
# fig.update_layout(
# 	title="Stalls (Normalized to Instructions Executed)",
#     template=presentation_template
# )
# fig.show()
# fig.write_image(output_dir+'/stalls.pdf')

#IPC
# ipc_data = graph_data_frame[['benchmark', 'IPCx1M']]
# ipc_data['IPCx1M'] = ipc_data['IPCx1M'] / 1000000
# ipc_fig = px.bar(ipc_data.melt(id_vars="benchmark"), x='benchmark', color="variable", y='value',  range_y=[0, 1])
# ipc_fig.update_layout(
# 	title="Embench IPC",
#     template=presentation_template
# )
# ipc_fig.show()
# ipc_fig.write_image(output_dir+'/ipc.pdf')

#IPC-delta
# ref_ipc_data = ref_graph_data_frame[['benchmark', 'IPCx1M']]
# ipc_data = graph_data_frame[['benchmark', 'IPCx1M']]
# ipc_delta = ipc_data

# ipc_delta['IPCx1M'] = ipc_data['IPCx1M'] # / ref_ipc_data['IPCx1M']
# ipc_delta['IPCx1M'] = 100* (ipc_delta['IPCx1M'] - 1)

# ipc_delta_fig = px.bar(ipc_delta.melt(id_vars="benchmark"), x='benchmark', color="variable", y='value',  range_y=[-20, 20])
# ipc_delta_fig.update_layout(
# 	title="Embench IPC", # Delta",
#     template=presentation_template
# )
# ipc_delta_fig.show()
# ipc_delta_fig.write_image(output_dir+'/ipc_delta.pdf')

#Misses per thousand instructions
# misspredict_data = graph_data_frame[['benchmark', 'branch_misspredict']]
# issued_data = graph_data_frame[['benchmark', 'instruction_issued_dec']]
# mpki = misspredict_data
# mpki['branch_misspredict'] = misspredict_data['branch_misspredict'] / issued_data['instruction_issued_dec']
# mpki['branch_misspredict'] = 1000* (mpki['branch_misspredict'])

# mpki_fig = px.bar(mpki.melt(id_vars="benchmark"), x='benchmark', color="variable", y='value')
# mpki_fig.update_layout(
# 	title="Misses Per Thousand Instructions (MPKI)",
#     template=presentation_template
# )
# mpki_fig.show()
