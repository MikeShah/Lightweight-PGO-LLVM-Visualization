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

        bool runOnFunction(Function &F) override {

        // Function* targetFunc = ... Could be this instruction 'F'

        outs() << F.getName() << " has " << F.size() << "\n";
        outs() << F.getName() << "arguments: \n";

        // Loop through Basic Blocks
        Function::iterator b = F.begin();
        BasicBlock::iterator i;
        BasicBlock::iterator e;

        for(i = b->begin(), e = b->end(); i != e; ++i){
            outs() << "\tBasic:" << b->size() << "\n";
            if(CallInst* callInst = dyn_cast<CallInst>(&*i)){
                Function* calledFunction = callInst->getCalledFunction(); // Function we are calling
                outs() << "calledFunction: " << calledFunction->getName() << "\n";
            }
        }

        //for(Function::iterator i = )
        /*
            for(Module::const_iterator i = M->getFunctionList().begin(),
                                       e = M->getFunctionList().end(); i != e; ++i){
                if(!i->isDeclaration()){
                    /// outs() - This returns a reference to a raw_ostream for standard output.
                    outs() << i->getName() << " has " << i->size() << " basic block(s).\n";
               }
            }
        */
            return false;
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
