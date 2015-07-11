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
            errs() << "Function " << F.getName() << '\n';

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
                }
            }

            std::map<std::string, int>::iterator i = opcodeCounter.begin();
            std::map<std::string, int>::iterator e = opcodeCounter.end();
            while(i != e){
                llvm::outs() << i-> first << ": " << i->second << "\n";
                i++;
            }
            llvm::outs() << "\n";
            opcodeCounter.clear();


            return false;
        }

    };
}

char MyOpCodeCounter::ID = 0;
static RegisterPass<MyOpCodeCounter> X("myopcodecounter", "Analysis Pass to Count Op Codes",false,false);

