from subprocess import call
import os
import time

# This is the variable you change in order to choose a name for your program
# No need to touch anything else
PROGRAM_1 = 'randprog1'

PROGRAM_1_GENERATE = PROGRAM_1+'.cpp' # Name of the .cpp file generated
PROGRAM_1_OUT = PROGRAM_1+'.ll'       # The textual bitcode representation output

DIR = './RandomPrograms/'

# Location at which CSmith is located on your drive.
# Needed if <csmith.h> is not on your path
CSMITH_DIR = '#include "/home/mdshah/Desktop/Csmith/csmith/runtime/csmith.h"'

######################## Generate a random program ##########################
print('Generating Random Program')
os.system('~/Desktop/Csmith/csmith/src/csmith --lang-cpp --no-comma-operators --no-longlong --no-int8 --no-uint8 --no-int8 --no-uint8 --no-math64 --no-packed-struct --no-pointers --quiet --no-volatile-pointers --no-consts --concise --output ./RandomPrograms/deleteme.cpp')

time.sleep(1)

print('Finding csmith.h and replacing with local path')
# Really hacky way to link to the Csmith header file
with open('./RandomPrograms/deleteme.cpp') as f:
	content = f.readlines()

with open('./RandomPrograms/'+PROGRAM_1_GENERATE,'w') as target:
	for line in content:
		if '#include "csmith.h"' in line:
			target.write('#include "/home/mdshah/Desktop/Csmith/csmith/runtime/csmith.h"')
			target.write('//// commented out'+line)
		else:
			target.write(line)
		


# Create bitcode from the random program.
print('Creating bitcode from random program')
os.system('../llvm/bin/clang -emit-llvm -S -g ./RandomPrograms/'+PROGRAM_1_GENERATE+' -o ./RandomPrograms/'+PROGRAM_1_OUT)  

# Attempt to build the random program (in case you want to run it)
print('Building program to ensure it is valid .cpp')
os.system('../llvm/bin/clang ./RandomPrograms/'+PROGRAM_1_GENERATE+' -g -o ./RandomPrograms/'+PROGRAM_1)

time.sleep(1)
