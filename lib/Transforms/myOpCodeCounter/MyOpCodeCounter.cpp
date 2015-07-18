#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"



#include <map>

using namespace llvm;

namespace {
    struct MyOpCodeCounter : public FunctionPass {
        // <opcode name, number of times it appears>
        std::map<std::string,int> opcodeCounter;

        static char ID;



        MyOpCodeCounter() : FunctionPass(ID){
        }

        virtual bool runOnFunction(Function &F) override {
            llvm::outs() << "====Function " << F.getName() << "====\n";

            // For all of our functions, get the basic blocks
            for(Function::iterator bb = F.begin(), e = F.end(); bb != e; ++bb){
                // Grab all of the basic blocks, and then iterate through their opcodes
                for(BasicBlock::iterator i = bb->begin(), e=bb->end(); i!= e; ++i){
                    // If the opcode is not in our map, then add it in, otherwise increment it.
                    if(opcodeCounter.find(i->getOpcodeName())==opcodeCounter.end()){
                        opcodeCounter[i->getOpcodeName()] = 1;
                    }else{
                        opcodeCounter[i->getOpcodeName()] += 1;
                    }

//                    outputInstructionData(i);
                }
            }

            std::map<std::string, int>::iterator i = opcodeCounter.begin();
            std::map<std::string, int>::iterator e = opcodeCounter.end();
            while(i != e){
                llvm::outs() << i->first << ": " << i->second << "\n";
                i++;
            }
            llvm::outs() << "\n";


            outs() << "\t============("<< F.getArgumentList().size() << ") arguments============\n";
            if(F.getArgumentList().size()>0){
                Function::arg_iterator f_i = F.arg_begin();
                Function::arg_iterator f_e = F.arg_end();


                for(; f_i != f_e; ++f_i){
                    Argument *Arg = f_i;
//                    outs() << "\t" << Arg->getArgNo() << "\t" << Arg->getName() << "\t" <<  Arg->getType() << "\n" ;
                }
            }

            opcodeCounter.clear();


            return false;
        }

        void outputInstructionData(Instruction* i) const {

                    // Found these values from lib\IR\Instruction.cpp
                    outs() << *i << '\n';
                    outs() << "mayReadFromMemory:" << i->mayReadFromMemory() << '\n';
                    outs() << "mayWriteToMemory:" << i->mayWriteToMemory() << '\n';
                    outs() << "isAtomic:" << i->isAtomic() << '\n';
                    outs() << "mayThrow:" << i->mayThrow() << '\n';
                    outs() << "mayReturn:" << i->mayReturn() << '\n';
                    outs() << "isAssociative:" << i->isAssociative() << '\n';
        }


        /*
                    // Categories based on: http://llvm.org/docs/doxygen/html/Instruction_8cpp_source.html
            llvm::outs()    << "Binary Op\t|Logical Op\t|Memory Instr\t|Convert Insrt\t|Other\t|Invalid\n";
            llvm::outs()    << counts[0] << "\t\t" << counts[1] << "\t\t" << counts[2] << "\t\t"
                            << counts[3] << "\t\t" << counts[4] << "\t\t" << counts[5] << "\t\t"<< counts[6] << '\n';

        // Not useufl to do in C++, do this step in post-processing
        void buildOpCodeTable(std::string OpCode, int& counts){

              // Terminators
              if(OpCode.compare("Ret") ||
                 OpCode.compare("Br") ||
                 OpCode.compare("Switch") ||
                 OpCode.compare("IndirectBr") ||
                 OpCode.compare("Invoke") ||
                 OpCode.compare("Resume") ||
                 OpCode.compare("Unreachable")) {

                 counts[0]++;
                 return;
              }

              // Standard binary operators
              if(OpCode.compare("Add")  ||
                 OpCode.compare("FAdd") ||
                 OpCode.compare("Sub")  ||
                 OpCode.compare("FSub") ||
                 OpCode.compare("Mul")  ||
                 OpCode.compare("FMul") ||
                 OpCode.compare("UDiv") ||
                 OpCode.compare("SDiv") ||
                 OpCode.compare("FDiv") ||
                 OpCode.compare("URem") ||
                 OpCode.compare("SRem") ||
                 OpCode.compare("FRem")) {

                 counts[1]++;
                 return;
              }

              // Logical operators
              if(OpCode.compare("And")  ||
                 OpCode.compare("Or")   ||
                 OpCode.compare("Xor")) {

                 counts[2]++;
                 return;
              }

              // Memory instructions
              if(OpCode.compare("Alloca")   ||
                 OpCode.compare("Load")     ||
                 OpCode.compare("Store")    ||
                 OpCode.compare("AtomicCmpXchg") ||
                 OpCode.compare("AtomicRMW")||
                 OpCode.compare("Fence")    ||
                 OpCode.compare("GetElementPtr")) {

                 counts[3]++;
                 return;
              }

              // Convert instructions
              if(OpCode.compare("Trunc")    ||
                 OpCode.compare("ZExt")     ||
                 OpCode.compare("SExt")     ||
                 OpCode.compare("FPTrunc")  ||
                 OpCode.compare("FPExt")    ||
                 OpCode.compare("FPToUI")   ||
                 OpCode.compare("FPToSI")   ||
                 OpCode.compare("UIToFP")   ||
                 OpCode.compare("SIToFP")   ||
                 OpCode.compare("IntToPtr") ||
                 OpCode.compare("PtrToInt") ||
                 OpCode.compare("BitCast")  ||
                 OpCode.compare("AddrSpaceCast")) {

                 counts[4]++;
                 return;
              }

              // Other instructions...
              if(OpCode.compare("ICmp")     ||
                 OpCode.compare("FCmp")     ||
                 OpCode.compare("PHI")      ||
                 OpCode.compare("Select")   ||
                 OpCode.compare("Call")     ||
                 OpCode.compare("Shl")      ||
                 OpCode.compare("LShr")     ||
                 OpCode.compare("AShr")     ||
                 OpCode.compare("VAArg")    ||
                 OpCode.compare("ExtractElement") ||
                 OpCode.compare("InsertElement")||
                 OpCode.compare("ShuffleVector")||
                 OpCode.compare("ExtractValue") ||
                 OpCode.compare("InsertValue")  ||
                 OpCode.compare("LandingPad")) {

                 counts[5]++;
                 return;
              }

                counts[6]++;
                return;

            } // end  void buildOpCodeTable(unsigned OpCode)
            */
    }; // end struct MyOpCodeCounter : public FunctionPass {
}

char MyOpCodeCounter::ID = 0;
static RegisterPass<MyOpCodeCounter> X("myopcodecounter", "Analysis Pass to Count Op Codes",false,false);

