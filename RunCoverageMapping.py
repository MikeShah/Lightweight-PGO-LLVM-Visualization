from subprocess import call
import os
import time

# This is the variable you change in order to choose a name for your program
# No need to touch anything else
PROGRAM_1 = 'randprog1'

PROGRAM_1_GENERATE = PROGRAM_1+'.cpp' # Name of the .cpp file generated
PROGRAM_1_OUT = PROGRAM_1+'.ll'       # The textual bitcode representation output

DIR = './RandomPrograms/'


################### Build an instrumented version of program with Coverage Mapping ##############
print('|==========Performing Code Coverage========|')
os.system('../llvm/bin/clang -o '+DIR+'randprog1 -fprofile-instr-generate -fcoverage-mapping ./RandomPrograms/randprog1.cpp')

# Run the program
os.system(DIR+PROGRAM_1)

# Merge the data
os.system('../llvm/bin/llvm-profdata merge -o '+DIR+PROGRAM_1+'.profdata default.profraw')
print('Code output to randprog1_code_coverage_report.txt')

# Output the code coverage
os.system('../llvm/bin/llvm-cov show '+DIR+PROGRAM_1+' -instr-profile='+DIR+PROGRAM_1+'.profdata '+DIR+PROGRAM_1_GENERATE+' > '+DIR+PROGRAM_1+'_code_coverage_report.txt')
