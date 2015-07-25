#include "llvm/ADT/Statistic.h"

#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/IR/CallSite.h"

#include <set>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "hello"

// Helper method for converting the name of a LLVM type to a string
static std::string LLVMTypeAsString(const Type *T) {
  std::string TypeName;
  raw_string_ostream N(TypeName);
  T->print(N);
  return N.str();
}

namespace {
  // Hello - The first implementation, without getAnalysisUsage.
  struct MyModulePass2 : public ModulePass {
    static char ID; // Pass identification, replacement for typeid
    MyModulePass2() : ModulePass(ID) {}

    std::set<const Value*> Vals;

    bool runOnModule(Module &M) override {

            //std::vector<std::string> functionList;
            /*
              for(Module::global_iterator I = M.global_begin(), E = M.global_end(); I != E; ++I) {
                Vals.insert(&*I);
                for (User::const_op_iterator OI = I->op_begin(), OE = I->op_end(); OI != OE; ++OI)
                  Vals.insert(*OI);
              }
            */
            Module &module = M;
            for (Function &fun : module) {
                for (BasicBlock &bb : fun) {
                    for (Instruction &i : bb) {
                         CallSite cs(&i);
                         if (!cs.getInstruction()) {
                            continue;
                         }
                         outs() << "Found a function call: " << i << "\n";
                         Value *called = cs.getCalledValue()->stripPointerCasts();
                         if (Function *f = dyn_cast<Function>(called)) {
                            outs() << "Direct call to function: " << f->getName() << "\n";
                         }
                    }
                }
            }

            //llvm::iplist<Function> myList(M.getFunctionList());
            outs () << "===v Getting functions from module v===\n";
            Module::FunctionListType &functions = M.getFunctionList();
            for(Module::FunctionListType::iterator it = functions.begin(), it_end = functions.end(); it != it_end; ++it){
                outs() << it->getName() << "\n";
            }
            outs () << "===^ Getting functions from module ^===\n";
                // Get the function name
                for(Module::iterator I = M.begin(), E = M.end(); I != E; ++I){
                    if(!I->isDeclaration()){
                        outs() << "Function name: " << I->getName() << "\n";
                        // Get the arguments of that function
                        for (Function::arg_iterator AI = I->arg_begin(), AE = I->arg_end(); AI != AE; ++AI){
                            Argument *Arg = AI;
                            outs() << "\t" << Arg->getArgNo() << "\t" << Arg->getName() << "\t" << LLVMTypeAsString(Arg->getType()) << "\n" ;
                        }
                        for (Function::const_iterator FI = I->begin(), FE = I->end(); FI != FE; ++FI){
                            outs() << "\tblock name? " << FI->getName() << "\n";
                        }
                    }

                /*
               Vals.insert(&*I);
                if(!I->isDeclaration()) {
                  for (Function::arg_iterator AI = I->arg_begin(), AE = I->arg_end(); AI != AE; ++AI)
                    Vals.insert(&*AI);
                  for (Function::const_iterator FI = I->begin(), FE = I->end(); FI != FE; ++FI)
                    for (BasicBlock::const_iterator BI = FI->begin(), BE = FI->end(); BI != BE; ++BI) {
                      Vals.insert(&*BI);
                      for (User::const_op_iterator OI = BI->op_begin(), OE = BI->op_end(); OI != OE; ++OI)
                        Vals.insert(*OI);
                    }
                }
                */
              }

/*
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
*/

      return false;
    }
  };
}

char MyModulePass2::ID = 0;
static RegisterPass<MyModulePass2> X("mymodulepass2", "A first pass we've created");
