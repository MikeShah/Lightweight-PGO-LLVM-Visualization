/*
#include "llvm/InitializePasses.h"
#include "llvm/LinkAllPasses.h"
#include "llvm/Analysis/Passes.h"
#include "llvm/lib/Analysis.h"

#include "llvm/Pass.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"


using namespace llvm;

namespace {
    struct MyAliasAnalysis : public ImmutablePass, public AliasAnalysis {
        static char ID;

        MyAliasAnalysis() : ImmutablePass(ID){
            initializeMyAliasAnalysis(*PassRegistry::getPassRegistry());
        }

        void *getAdjustedAnalysisPointer(const void *ID) override{
        }

        bool doInitialization(Module &M) override{
            return true;
        }

        void *getAdjustedAnalysisPointer(const void *ID) override{
        }

    };
}

char MyAliasAnalysis::ID = 0;
INITIALIZE_AG_PASS(MyAliasAnalysis, AliasAnalysis, "must-aa", "Returns true if always alias", true, true, true)
ImmutablePass *llvm::createMyAliasAnalysisPass(){
    return new MyAliasAnalysis();
}
*/
