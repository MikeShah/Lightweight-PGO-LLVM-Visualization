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
    struct MyAddCounter : public FunctionPass {

        static char ID;



        MyAddCounter() : FunctionPass(ID){
        }

        virtual bool runOnFunction(Function &F) override {
            errs() << "Function " << F.getName() << '\n';

            //AllocaInst *ai = new AllocaInst(Type::Int32Ty,0,"mikeAllocation");
            //Instruction *newInst = new Instruction(ai);



            // For all of our functions, get the basic blocks
            for(Function::iterator bb = F.begin(), e = F.end(); bb != e; ++bb){
                // Grab all of the basic blocks, and then iterate through their opcodes

                // Get the first basic block
                BasicBlock* firstblock = bb->begin();
                firstblock->getInstList().insert(createAddInstruction,firstblock);


           //     for(BasicBlock::iterator i = bb->begin(), e=bb->end(); i!= e; ++i){
                    // If the opcode is not in our map, then add it in, otherwise increment it.
//                    i->getInstList().insert(createAddInstruction(F);)
           //     }
            }


            return true;
        }

        static BasicBlock *createAddInstruction(Function& F, BasicBlock &b)
        {
            // Function::getContext returns a mutable reference to LLVMContext. By assigning it in:
            // http://stackoverflow.com/questions/30267023/llvm-functiongetcontext-private-within-this-context
            BasicBlock* bb = BasicBlock::Create(F.getContext(), "EntryBlock",F,b);

            return bb;
        }

    };
}

char MyAddCounter::ID = 0;
static RegisterPass<MyAddCounter> X("myaddcounter", "Generates a modified program with counters",false,false);

