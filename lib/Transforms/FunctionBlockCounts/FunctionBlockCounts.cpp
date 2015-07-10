#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"


using namespace llvm;

namespace {
    struct FunctionBlockCounts : public FunctionPass {
        static char ID;

        FunctionBlockCounts() : FunctionPass(ID){
        }

        virtual void getAnalysisUsage(AnalysisUsage &AU) const {
            AU.setPreservesCFG();
            AU.addRequired<LoopInfoWrapperPass>();
        }

        virtual bool runOnFunction(Function &F) override {
            // Function* targetFunc = ... Could be this instruction 'F'
            outs() << F.getName() << " has size of " << F.size() << "\n";
            outs() << "\t============("<< F.getArgumentList().size() << ") arguments============\n";
            if(F.getArgumentList().size()>0){
                Function::arg_iterator f_i = F.arg_begin();
                Function::arg_iterator f_e = F.arg_end();

                for(; f_i != f_e; ++f_i){
                    Argument *Arg = f_i;
                    outs() << "\t" << Arg->getArgNo() << "\t" << Arg->getName() << "\t" << Arg->getType() << "\n" ;
                }
            }

            outs() << "\t============================================================\n";
            outs() << "\tUses variable sized arguments: " << F.isVarArg() << "\n";
            outs() << "\tIs function streamed in from disk(or other source): " << F.isMaterializable() << "\n";
            outs() << "\tIs function intrinsic (specially handled by compiler): " << F.isIntrinsic() << "\n";
            outs() << "\tFunction does NOT read memory: " << F.doesNotAccessMemory() << "\n";
            outs() << "\t============================================================\n";




            // Loop through Basic Blocks
            Function::iterator b = F.begin();
            BasicBlock::iterator i;
            BasicBlock::iterator e;

            outs() << "\t has " << b->size() << " in iterator collection.\n";
            outs() << "\t====================Functions Called=====================\n";
            for(i = b->begin(), e = b->end(); i != e; ++i){
                if(CallInst* callInst = dyn_cast<CallInst>(&*i)){
                    Function* calledFunction = callInst->getCalledFunction(); // Function we are calling
                    outs() << "\tcalledFunction: " << calledFunction->getName() << "\n";
                }
            }

            // Gather loop information
            LoopInfo *LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
            for(Loop *L : *LI){
                countBlocksInLoop(L,0);
            }

            return false;
        }


        void countBlocksInLoop(Loop *L, unsigned nest){
            unsigned num_Blocks = 0;
            Loop::block_iterator bb;
            for(bb = L->block_begin(); bb != L->block_end(); ++bb){
                num_Blocks++;
            }

            // Output a number of tabs to format output
            for(unsigned int indentation = 0; indentation < nest; indentation++){
                errs() << "\t";
            }
            errs() << "\tLoop Level " << nest << " has " << num_Blocks << " blocks\n";

            std::vector<Loop*> subLoops = L->getSubLoops();
            Loop::iterator j,f;
            for(j = subLoops.begin(), f = subLoops.end(); j != f; ++j){
                countBlocksInLoop(*j, nest + 1);
            }
        }

    };
}

char FunctionBlockCounts::ID = 0;
static RegisterPass<FunctionBlockCounts> X("functionblockcounts", "Returns Function Sizes",false,false);

/*
#include "llvm/Bitcode/ReaderWriter.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_os_ostream.h"
#include "llvm/Support/ErrorOr.h"

#include <iostream>

using namespace llvm;

static cl::opt<std::string> FileName(cl::Positional,cl::desc("Bitcode file"),cl::Required);

int main(int argc, char** argv){

    cl::ParseCommandLineOptions(argc,argv,"LLVM hello world\n");
    LLVMContext context;
    std::string error;

    ErrorOr<std::unique_ptr<MemoryBuffer>> mb = MemoryBuffer::getFile(FileName);
    if(std::error_code ec = mb.getError()){
        errs() << ec.message();
        return -1;
    }


    ErrorOr<Module *> m = parseBitcodeFile((*mb)->getMemBufferRef(),context);
    if(std::error_code ec = m.getError()){
        errs() << "Error reading bitcode: " << ec.message();
        return -1;
    }

    for(Module::const_iterator i = (*m)->getFunctionList().begin(),
                               e = (*m)->getFunctionList().end(); i != e; ++i){
        if(!i->isDeclaration()){
            /// outs() - This returns a reference to a raw_ostream for standard output.
           // outs() << i->getName() << " has " << i->size() << " basic block(s).\n";
           outs() << i->getName();
        }
    }


    return 0;
}
*/
