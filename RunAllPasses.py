from subprocess import call
import os
import time

# This is the variable you change in order to choose a name for your program
# No need to touch anything else
PROGRAM_1 = 'randprog1'

PROGRAM_1_GENERATE = PROGRAM_1+'.cpp' # Name of the .cpp file generated
PROGRAM_1_OUT = PROGRAM_1+'.ll'       # The textual bitcode representation output

DIR = './RandomPrograms/'


#### BElOW ARE VARIOUS PASSES ####
# Run them all or just one at a time to test them

################# Command line to run FuncBlockCount ###################
print('|==========Running "funcblockcount"===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/funcblockcount.so -funcblockcount ./RandomPrograms/'+PROGRAM_1_OUT+' -o '+DIR+PROGRAM_1_OUT+'.bc')

################## Command line to run FunctionBlockCounts ##############
print('|==========Running "functionblockcounts"==========|')
os.system('../llvm/bin/opt -load ../llvm/lib/functionblockcounts.so -functionblockcounts '+DIR+PROGRAM_1_OUT+' -o '+DIR+PROGRAM_1_OUT+'.bc')


############# Command line to count opcodes in an analysis pass #############
print('|==========Running "myopcodecounter"===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/myopcodecounter.so -myopcodecounter '+DIR+PROGRAM_1_OUT+' -o '+DIR+PROGRAM_1_OUT+'.bc > '+DIR+PROGRAM_1+'.opcodecount')

############### Command line to run pass that adds counters to program #############
print('|==========Instrumenting binary and going to re-run===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/myaddcounter.so -myaddcounter '+DIR+PROGRAM_1_OUT+' -o '+DIR+PROGRAM_1_OUT+'.bc')


############### Command line to perform Alias Analysis ################
print('|=========Running must-aa analysis============|')
os.system('../llvm/bin/opt -load ../llvm/lib/myaliasanalysis.so -must-aa '+DIR+PROGRAM_1_OUT)

############### Command line to perform Module Pass ##################
print('|=========Running Module Pass===========|')
os.system('../llvm/bin/opt -load ../llvm/lib/mymodulepass.so -mymodulepass '+DIR+PROGRAM_1_OUT)

