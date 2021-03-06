from subprocess import call
import os

# This is the variable you change in order to choose a name for your program
# No need to touch anything else
PROGRAM_1 = 'randprog1'

PROGRAM_1_GENERATE = PROGRAM_1+'.cpp' # Name of the .cpp file generated
PROGRAM_1_OUT = PROGRAM_1+'.ll'       # The textual bitcode representation output

DIR = './RandomPrograms/'

# Generate a random program
print('Generating Random Program')
os.system('~/Desktop/Csmith/csmith/src/csmith --lang-cpp --no-comma-operators --no-longlong --no-int8 --no-uint8 --no-int8 --no-uint8 --no-math64 --no-packed-struct --no-pointers --quiet --no-volatile-pointers --no-consts --concise --output ./RandomPrograms/deleteme.cpp')

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
os.system('../llvm/bin/clang -emit-llvm -S ./RandomPrograms/'+PROGRAM_1_GENERATE+' -o ./RandomPrograms/'+PROGRAM_1_OUT)  

# Attempt to build the random program (in case you want to run it)
print('Building program to ensure it is valid .cpp')
os.system('../llvm/bin/clang ./RandomPrograms/'+PROGRAM_1_GENERATE+' -o ./RandomPrograms/'+PROGRAM_1)


#### BElOW ARE VARIOUS PASSES ####
# Run them all or just one at a time to test them

# Command line to run FuncBlockCount
print('|==========Running "funcblockcount"===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/funcblockcount.so -funcblockcount ./RandomPrograms/'+PROGRAM_1_OUT+' -o ./RandomPrograms/'+PROGRAM_1_OUT+'.bc')

# Command line to run FunctionBlockCounts
print('|==========Running "functionblockcounts"==========|')
os.system('../llvm/bin/opt -load ../llvm/lib/functionblockcounts.so -functionblockcounts ./RandomPrograms/'+PROGRAM_1_OUT+' -o '+PROGRAM_1_OUT+'.bc')


# Command line to count opcodes in an analysis pass
print('|==========Running "myopcodecounter"===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/myopcodecounter.so -myopcodecounter ./RandomPrograms/'+PROGRAM_1_OUT+' -o '+PROGRAM_1_OUT+'.bc')

# Command line to run pass that adds counters to program
print('|==========Instrumenting binary and going to re-run===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/myaddcounter.so -myaddcounter ./RandomPrograms/'+PROGRAM_1_OUT+' -o '+PROGRAM_1_OUT+'.bc')


# Build an instrumented version of program with Coverage Mapping
print('|==========Performing Code Coverage========|')

os.system('../llvm/bin/clang -o '+DIR+'randprog1 -fprofile-instr-generate -fcoverage-mapping ./RandomPrograms/randprog1.cpp')

# Run the program
os.system(DIR+PROGRAM_1)

# Merge the data
os.system('../llvm/bin/llvm-profdata merge -o '+DIR+PROGRAM_1+'.profdata default.profraw')
print('Code output to randprog1_code_coverage_report.txt')
# Output the code coverage
os.system('../llvm/bin/llvm-cov show '+DIR+PROGRAM_1+' -instr-profile='+DIR+PROGRAM_1+'.profdata '+DIR+PROGRAM_1_GENERATE+' > '+DIR+PROGRAM_1+'_code_coverage_report.txt')



