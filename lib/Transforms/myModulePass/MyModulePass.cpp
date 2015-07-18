
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"


using namespace llvm;


namespace {
    struct MyModulePass : public ModulePass {
        static char ID;

        MyModulePass() : ModulePass(ID)
        {}


        void getAnalysisUsage(AnalysisUsage &AU) const override{
        }

        bool runOnModule(Module &M) override {
            errs() << M.getName() << '\n';
            return false;
        }

    };

}

char MyModulePass::ID = 0;
static RegisterPass<MyModulePass> X("mymodulepass", "Generic Module Pass I am testing",false,false);
