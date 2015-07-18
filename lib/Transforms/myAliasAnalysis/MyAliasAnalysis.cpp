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
            initializeAnalysis(*PassRegistry::getPassRegistry());
        }

        void *getAdjustedAnalysisPointer(const void *ID) override{
            if(ID== &AliasAnalysis::ID){
                return (AliasAnalysis*)this;
            }
            return this;
        }

        bool doInitialization(Module &M) override{
            DL = &M.getDataLayout();
            return true;
        }


    };
}

namespace llvm{
    void initializeMyAliasAnalysisPass(PassRegistry &Registry);
}

char MyAliasAnalysis::ID = 0;
//INITIALIZE_AG_PASS(MyAliasAnalysis, AliasAnalysis, "must-aa", "Returns true if always alias", true, true, true)
static RegisterPass<MyAliasAnalysis> A("must-aa", "Returns true if always alias", false, true);

/*ImmutablePass *llvm::createMyAliasAnalysisPass(){
    return new MyAliasAnalysis();
}
*/

