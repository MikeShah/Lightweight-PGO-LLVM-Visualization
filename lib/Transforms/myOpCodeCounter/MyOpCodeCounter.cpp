#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"

#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DebugInfoMetadata.h"

#include <map>
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {
    struct MyOpCodeCounter : public FunctionPass {
        // <opcode name, number of times it appears>
        std::map<std::string,int> opcodeCounter;

        static char ID;



        MyOpCodeCounter() : FunctionPass(ID){

        }

        virtual bool runOnFunction(Function &F) override {

            std::string s;
            llvm::raw_string_ostream ss(s);

            ss  << "{\n"
                << "\"functionName\": \"" << F.getName() << "\",\n"
                << "\"size\": "<< F.size() << ",\n";

            ss << "\"InstructionData\":[";
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

                    // !i==e is a clever-ish way of saying
                    // 'hey man, if we're going to be on our last instruction
                    // then just don't emit that last comma so JSON doesn't complain.
                    // No, this code is not readable, but making an annoying if-condition is annoying.
                    // The ternary operator would also make this code too long to fit on my screen.
                    ss << outputInstructionData(i,!(i==e)); // move iterator back after incrementing

                }
            }
            ss << "\t]\n}\n";

            // Output instruction breakdown
            /*
            std::map<std::string, int>::iterator i = opcodeCounter.begin();
            std::map<std::string, int>::iterator e = opcodeCounter.end();
            ss << "\t{\"instructionCounts\": [\n";
            while(i != e){
                ss << "\t\t \"{"<< i->first << "\" : " << i->second << "},\n";
                i++;
            }
            ss << "\t]}\n";
            */

            // outs() << "\t============("<< F.getArgumentList().size() << ") arguments============\n";
            //ss << outputFunctionArguments(F);

            // Just perform one write to the buffer
            outs() << ss.str();


/*
            // Categories based on: http://llvm.org/docs/doxygen/html/Instruction_8cpp_source.html
            llvm::outs()    << "Binary Op\t|Logical Op\t|Memory Instr\t|Convert Insrt\t|Other\t|Invalid\n";
            llvm::outs()    << counts[0] << "\t\t" << counts[1] << "\t\t" << counts[2] << "\t\t"
                            << counts[3] << "\t\t" << counts[4] << "\t\t" << counts[5] << "\t\t"<< counts[6] << '\n';
*/
            opcodeCounter.clear();

            return false;
        }

        // Output debugging informaiton
        // See function: void DebugLoc::print(raw_ostream &OS) const
        // for example on printng out data
        //
        // The emit_comma is a workaround for printing out nice JSON data
        //
        std::string outputInstructionData(Instruction* i, bool emit_comma) const {
                    std::string s;
                    llvm::raw_string_ostream ss(s);

                    // Found these values from lib\IR\Instruction.cpp
                    ss << "\t{\n\t\"Instruction\":\"" << i->getOpcodeName() << "\",";

                    ss << "\n\t\"context\":\"" <<*i << "\",";
                    ss << "\n\t\"mayReadFromMemory\":" << i->mayReadFromMemory() << ",";
                    ss << "\n\t\"mayWriteToMemory\":" << i->mayWriteToMemory() << ",";
                    ss << "\n\t\"isAtomic\":" << i->isAtomic() << ",";
                    ss << "\n\t\"mayThrow\":" << i->mayThrow() << ",";
                    ss << "\n\t\"mayReturn\":" << i->mayReturn() << ",";
                    ss << "\n\t\"isAssociative\":" << i->isAssociative() << ",";

                    std::string callsFunction = "n/a";
                    if(CallInst* c = dyn_cast<CallInst> (i)){
                        Function* f2 = c->getCalledFunction	();
                        if(f2){
                            callsFunction = f2->getName();
                        }
                    }
                    ss << "\n\t\"callsfunction\": \"" << callsFunction << "\"\n";

                    //if (MDNode *N = i->getMetadata("dbg")) {  // Here I is an LLVM instruction

                    DebugLoc DL = i->getDebugLoc();
                    std::string filename = "";
                    unsigned int line = -1;
                    unsigned int column = -1;
                    if(DL){
                        DIScope *Scope = DL->getScope();
/*                      Not sure this is needed yet
                        if(DL.getInlinedAt()){
                            ss() << "Inlined:" << DL.getInlinedAt();
                        }
*/
                        // If we have additional debuggin info available
                        // then output that data.
                        filename = Scope->getFilename();
                        line = DL.getLine();
                        column = DL.getCol();
                    }

                    // Output data in JSon format
                    ss  << "\t,\"DebugData\": [{\"File\": \"" << filename
                    << "\" , \"Line Number\": " << line
                    << " , \"Column\": " << column << "}]}";

                    if(emit_comma){
                        ss << ",\n";
                    }
                    else{
                        ss << "\n";
                    }



            return ss.str();
        }

        // Outputs all of the function arguments
        std::string outputFunctionArguments(Function& F){
            std::string s;
            llvm::raw_string_ostream ss(s);
                if(F.getArgumentList().size()>0){
                    Function::arg_iterator f_i = F.arg_begin();
                    Function::arg_iterator f_e = F.arg_end();

                    ss << "\t{'arguments':\n";
                    for(; f_i != f_e; ++f_i){
                        Argument *Arg = f_i;
                        ss << "\t\t'getArgNo': '" << Arg->getArgNo() << "', 'name': '" << Arg->getName() << "', 'type': '" <<  Arg->getType() << "',\n" ;
                    }
                    ss << "\t}\n";
                }
            return s;
        }

    }; // end struct MyOpCodeCounter : public FunctionPass {
}

char MyOpCodeCounter::ID = 0;
static RegisterPass<MyOpCodeCounter> X("myopcodecounter", "Analysis Pass to Count Op Codes",false,false);









        // Not useufl to do in C++, do this step in post-processing
        /*
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
