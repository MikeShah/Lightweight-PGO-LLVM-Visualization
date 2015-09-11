import os

DIR = './RandomPrograms/'
PROG_NAME = 'randprog1'

# Run a pass to add attributes to our bitcode
os.system('../llvm/bin/opt -load ../llvm/lib/mymodulepass2.so -mymodulepass2 '+DIR+PROG_NAME+'.ll -o '+DIR+PROG_NAME+'.withattributes.bc')

# Disassemble the bitcode so that we have our IR in a textual form that we can analyze
# Essentially just overwrite the binary bitcode(bc) that we generated.
os.system('../llvm/bin/llvm-dis '+DIR+PROG_NAME+'.withattributes.bc -o '+DIR+PROG_NAME+'.withattributes.ll')

