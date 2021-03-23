import sys
import os

if ('TAIGA_PROJECT_ROOT' not in os.environ) :
	print ('Please set TAIGA_PROJECT_ROOT for logfile locations.')
	sys.exit(-1)

rootDir = os.environ.get('TAIGA_PROJECT_ROOT')

logFilePath = rootDir + '/logs/verilator/embench.log'

try:
    file  = open(logFilePath, 'r').read()
except IOError as e:
	print ('Failed to open embench log: ' + e)
	sys.exit(-1)

if (file.count('CORRECT') == 19) :
    print ('EMBENCH PASSED')
    sys.exit(0)
else :
    print ('EMBENCH FAILED')
    sys.exit(-1)