import subprocess
import time

######################## Generate a random program ##########################
execfile("RunGenerateRandomProgram.py")
######################## Run all of the Passess #############################
execfile("RunAllPasses.py")
######### Build a version of the program with attributes ##########
execfile("RunAddAttributes.py")
###### Build an instrumented version of program with Coverage Mapping ######
execfile("RunCoverageMapping.py")
######### Differentiate between optimized file and unoptimized one #########
execfile("RunDiffTool.py")
