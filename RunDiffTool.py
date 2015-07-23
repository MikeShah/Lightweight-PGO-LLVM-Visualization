from subprocess import call
import os
import time

# This is the variable you change in order to choose a name for your program
# No need to touch anything else
PROGRAM_1 = 'randprog1'

PROGRAM_1_GENERATE = PROGRAM_1+'.cpp' # Name of the .cpp file generated
PROGRAM_1_OUT = PROGRAM_1+'.ll'       # The textual bitcode representation output

DIR = './RandomPrograms/'

###########3 Differentiate between optimized file and unoptimized one ##################3
print('Emitting -O2 version of .ll to compare')
os.system('../llvm/bin/clang -g -O2 -emit-llvm -S '+DIR+PROGRAM_1_GENERATE+' -o '+DIR+'randprog1.O2.ll ')

os.system('diff -y --suppress-common-lines '+DIR+'randprog1.O2.ll '+DIR+PROGRAM_1_OUT+' > '+DIR+'randprog1.optimized.diff')

