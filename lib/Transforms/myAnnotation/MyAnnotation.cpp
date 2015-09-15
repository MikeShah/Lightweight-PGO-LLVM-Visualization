
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Instructions.h"

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"

#include <fstream>
#include <istream>

using namespace llvm;

/*
    Custom annotation data

    Takes in a string and parses it into the three fields
*/
struct myCustomAnnotation{
    std::string m_functionName;
    std::string m_annotation;
    std::string m_value;


    myCustomAnnotation(std::string line){
        std::string buf;

        int state = 0;

        for(unsigned i = 0; i < line.length(); ++i){
            // Build up our buffer
            if(line[i]=='\"'){
                // ignore these quotation marks
            }
            else if(line[i] !=' ' && line[i] != '\n'){
                buf+= line[i];
            }
            else{
                if(0==state){
                    m_functionName = buf;
                }else if(1 == state){
                    m_annotation = buf;
                }else if(2==state){
                    m_value = buf;
                }
                buf="";
                state++;
            }
        }

        errs() << m_functionName << " " << m_annotation << " " << m_value << '\n';
    }

private:


};


namespace {
    struct MyAnnotation : public ModulePass {
        static char ID;

        MyAnnotation() : ModulePass(ID)
        {}


        void getAnalysisUsage(AnalysisUsage &AU) const override{

        }

        bool runOnModule(Module &M) override {
            // (1) Read in an input file
            //     Store the input in a vector
            std::vector<myCustomAnnotation> functionsFound;

            std::ifstream  myfile("//home//mdshah//Desktop//GitRepo//Lightweight-PGO-LLVM-Visualization//ChordPlot//ChordPlot//annotations.txt");
            std::string line;
            if (myfile.is_open()){
                while ( getline (myfile,line) ){
                  errs() << "reading: " << line << '\n';
                  myCustomAnnotation temp(line);
                  functionsFound.push_back(temp);
                }
                myfile.close();
            }
            else{
                errs() << "\nError: Unable to open file - Possible bad path\n";
            }

            // (1.5) Store functions in this vector


            // (2)  For each function name that matches
            //      add an attribute to that function with the
            //      corresponding attribute name and value.

            unsigned annotationsMade = 0;

            Module::FunctionListType &functions = M.getFunctionList();
            for(Module::FunctionListType::iterator it = functions.begin(), it_end = functions.end(); it != it_end; ++it){
                //errs() << "Function in IR found: " << it->getName() << '\n';
                for(unsigned i =0; i < functionsFound.size(); ++i){
                    //errs() << functionsFound[i].m_functionName << " == " << it->getName() << '\n';
                    if(functionsFound[i].m_functionName==it->getName()){
                        errs() << "Adding " << functionsFound[i].m_annotation << " attribute to: " << it->getName() << '\n';
                        ++annotationsMade;
                        it->addFnAttr(functionsFound[i].m_annotation);

                        if(it->hasFnAttribute(functionsFound[i].m_annotation)){
                            /* Modify the first instruction with our annotation */
                            for(Function::iterator bb = it->begin(), e = it->end(); bb != e; ++bb){
                                for(BasicBlock::iterator i = bb->begin(), e=bb->end(); i!= e; ++i){
                                    LLVMContext& C = i->getContext();
                                    MDNode* N = MDNode::get(C, MDString::get(C, "my md string content"));
                                    i->setMetadata("my.md.name", N);
                                }
                            }
                        }

                        break;
                    }
                }
            }



            // (3) Output some information
            errs() << "Annotations made: " << annotationsMade << "\n";

            return true;
        }

    };

}

char MyAnnotation::ID = 0;
static RegisterPass<MyAnnotation> X("myannotation", "Reads in an annotation file and does stuff",false,false);
