#include "llvm/ADT/Statistic.h"

#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Casting.h"

#include "llvm/IR/CallSite.h"

#include "llvm/IR/MDBuilder.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Attributes.h"

#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"

#include <set>
#include <vector>
#include <memory>
#include <list>


using namespace llvm;

#define DEBUG_TYPE "hello"



// Helper method for converting the name of a LLVM type to a string
static std::string LLVMTypeAsString(const Type *T) {
  std::string TypeName;
  raw_string_ostream N(TypeName);
  T->print(N);
  return N.str();
}

/*! \brief FunctionData
 *         Holds information about functions
 *
 *  Holds data about individual functions, attributes, (eventually intrinsics), and PGO Data.
 *
 *
 *  TODO:
 */
class FunctionData{
private:
    Function* m_function;

    // Stores the function call sites
    // The function it calls, and how many times that function is called in total
    std::vector<std::pair<std::string,unsigned long int>> m_CallSites;
    // The attributes the function has
    std::vector<std::string> m_attributes;
    // The functions arguments
    std::vector<std::string> m_arguments;
    // Stores the opcodes
    std::map<std::string,unsigned> opcodeCounter;
    //std::set<const Value*> Vals;

    // Prints out all of the functions and their associated metadata
    void storeMetaData(){
        std::string s;
        llvm::raw_string_ostream ss(s);

        if(m_function->hasMetadata()){
                //for(Function::iterator bb = mi.begin(), E = mi.end(); bb != E; ++bb){
                SmallVector< std::pair<unsigned, MDNode*>, 4> MDForFunction;

                m_function->getAllMetadata(MDForFunction);

                unsigned mdCount = 0;
                for(SmallVector< std::pair<unsigned, MDNode*>, 4>::iterator sv_i = MDForFunction.begin(),
                                                                            sv_e = MDForFunction.end();
                                                                            sv_i != sv_e; ++sv_i){
                    ss << mdCount << " " ;
                    ++mdCount;
                    // Get the MDNode from the pair, and then output it
                    std::pair<unsigned, MDNode*> node = sv_i[0];
                    auto *N = dyn_cast<MDNode>(node.second);
                    ss << node.first << " = ";
                    // redirect the dump output
                    // FIXME: Print this out somewhere so we can reuse it
                    N->dump();
                    ss << "\n";
                }
                ss << "\n";

                // Iterate through each instruction in our basic block
                /*for(BasicBlock::iterator it = bb->begin(), ie = bb->end(); it!=ie; ++it){
                    mi.
                }
                */
            //}
        } // if(m_function->hasMetadata()){
    }

    // Prints out all of the function call sites
    void storeFunctionCallSites(){

        for (BasicBlock &bb : *m_function) {                    // Grab its basic block
            //ss << "\t: " << bb.getName() << "\n";   // For each instruction within our basic block
            for (Instruction &i : bb) {
                 CallSite cs(&i);                       // Find out where the callsite of the instruction is.
                 if (!cs.getInstruction()) {
                    continue;
                 }
                 Value *called = cs.getCalledValue()->stripPointerCasts();
                 if (Function *f = dyn_cast<Function>(called)) {
                    // ss << "\t\tFound a function call: " << i << "\n";    // Uncomment this line if we want function name
                    std::pair <std::string,unsigned long int> callSite;
                    // ss << "\t\tDirect call to function: " << f->getName() << "\n";
                    callSite.first = f->getName();

                   // Figure out how many entries into this function there are.
                    if(f->getEntryCount().hasValue()){
                        long unsigned int val = f->getEntryCount().getValue();
                        callSite.second = val;
                    }
                    else{
                        callSite.second = 0;
                    }

                    m_CallSites.push_back(callSite);
                 }
                 // Get all of the MetaData out from a node)
                 if(returnMetaData(i) != ""){
                    // FIXME: get the metadata working properly
                    // FIXME: The output is just from dump, and needs to be converted to a string
                    //returnMetaData(i);
                 }
            }
        }

    }

    // Takes an instruction and returns all
    // of the meta-data from it
    std::string returnMetaData(Instruction& i){
        if(MDNode* N = i.getMetadata("dbg")){

//            Context c = i.getContext();
            N->dump();
/*            DILocation Loc = i.getDebugLoc();
            //DILocation()

            unsigned Line = Loc.getLineNumber();
            StringRef File = Loc.getFilename();
            StringRef Dir = Loc.getDirectory();
            */
            return "meta-data not working yet";
        }
        else{
            return "";
        }
    }

    // This function prints out all of the attributes of an LLVM Function
    void storeAttributes(){
        AttributeSet attrs = m_function->getAttributes();

        for(unsigned i =0; i < attrs.getNumSlots(); ++i){
            m_attributes.push_back(attrs.getAsString(i,true));
        }

        //attrs.dump();

        /*
            int attrNumber = 0;
            for(AttributeSet::iterator i = attrs.begin(0), e = attrs.end(attrs.getNumSlots()); i != e; ++i){
                ss << i->getAsString(attrNumber);
                ++attrNumber;
            }
        */
    }

    // Store the function arguments
    void storeArguments(){
        std::string s="";
        llvm::raw_string_ostream ss(s);
        // Get the arguments of that function
        for (Function::arg_iterator AI = m_function->arg_begin(), AE = m_function->arg_end(); AI != AE; ++AI){
            Argument *Arg = AI;
            ss << Arg->getArgNo() << "\t" << Arg->getName() << "\t" << LLVMTypeAsString(Arg->getType()) << "\n" ;
            m_arguments.push_back(ss.str());
            s.clear();
            ss.flush();
        }
        /*
        for (Function::const_iterator FI = I->begin(), FE = I->end(); FI != FE; ++FI){
            ss << "\tblock name? " << FI->getName() << "\n";
        }
        */
    }

    // This function stores the opCodeCalls for each function
    void storeOpCodes(){
        // Get the function name

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

        for(Function::iterator bb = m_function->begin(), e = m_function->end(); bb != e; ++bb){
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

    }



    // Called from Constructors to gather data about functions.
    // Ideally, we could have different implementations of this
    // if we want to run a faster or more lightweight setup.
    //
    // Essentially what this function does is calls every private function
    // that gathers data.
    void init(){
        storeArguments();
        storeMetaData();
        storeFunctionCallSites();
        storeAttributes();
        storeOpCodes();
    }
public:
    // Constructor
    FunctionData(Function* F){
        m_function = F;
        init();
    }

    // Destructor

    // Prints out everything
    // Essentially this is just making a call
    // to every public function with a prefix 'print'
    std::string print(){
        std::string s="";
        llvm::raw_string_ostream ss(s);
        // Print the function name
        ss << "\n===Function Name===\n";
        ss << m_function->getName();
        // Print all of the functions arguments
        ss << "\n===Arguments===\n";
        ss << printArguments();
        // Print all of the call sites
        ss << "\n===Call Sites===\n";
        ss << printCallSites();
        // Print all of the functions attributes
        ss << "\n===Attributes===\n";
        ss << printAttributes();
        // Print all of the functions Instrution Opcodes
        ss << "\n===OpCodes===\n";
        ss << printOpCodes();

        return ss.str();
    }

    // Returns a formatted string with the function call sites
    std::string printCallSites(){
        std::string s="";
        llvm::raw_string_ostream ss(s);

        for(unsigned i =0; i < m_CallSites.size(); i++){
            std::pair<std::string,unsigned long int> cs = m_CallSites[i];
            ss << cs.first << "(" << cs.second << +")" << "\n";
        }
        return ss.str();
    }

    // Returns a string with the funtion attributes
    std::string printArguments(){
        std::string s="";
        llvm::raw_string_ostream ss(s);
        for(unsigned i =0; i < m_arguments.size(); i++){
            ss << m_arguments[i] << "\n";
        }
        return ss.str();
    }

    // Returns a string with the funtion attributes
    std::string printAttributes(){
        std::string s="";
        llvm::raw_string_ostream ss(s);
        for(unsigned i =0; i < m_attributes.size(); i++){
            ss << m_attributes[i] << "\n";
        }
        return ss.str();
    }

    // Prints out all of the opcodes
    std::string printOpCodes(){
        std::string s="";
        llvm::raw_string_ostream ss(s);

        for(std::map<std::string,unsigned>::iterator it = opcodeCounter.begin(), ie = opcodeCounter.end(); it != ie; ++it){
            ss << it->first << " : " << it->second << "\n";
        }


        return ss.str();
    }

};

/*! \brief QueryCallGraph
 *         Structure which holds a call graph of functions
 *
 *  Builds a call graph from function data
 *
 *
 *  TODO:
 */
class QueryCallGraph{
private:
    // Used to put all functions in here which have been marked asycnhronous
    std::set<Function*> async_fns;
    // The module we are analyzing
    Module* m_Module = NULL;
    // Stores the functions in a list data structure
    std::vector<FunctionData*> functionList;

    // Gets all of the functions in the module
    // Once we have them all, we can work with them to perform more data analysis
    void getFunctions()
    {
        Module::FunctionListType &functions = m_Module->getFunctionList();

        for(Module::FunctionListType::iterator it = functions.begin(), it_end = functions.end(); it != it_end; ++it){
            FunctionData* d = new FunctionData(it);
            functionList.push_back(d);
        }
    }

    // Helper Function that needs to be called from every constructor
    void init(){
    // (1) Allocate memory for a function list
        //functionList = new std::vector<FunctionData*>;
        getFunctions();
    }

public:

    // This functions takes in a module in which
    // a call graph will be generated from.
    QueryCallGraph(Module *M){
        m_Module = M;
        init();
    }

    ~QueryCallGraph(){
        // (1) Deallocate memory for a function list

    }


    // Prints out all of the functions
    // Essentially this just means calling 'print' from
    // each functionData(which contains an llvm::Function) in the functionList.
    std::string printFunctions(){
        std::string s;
        llvm::raw_string_ostream ss(s);
        for(unsigned i =0; i < functionList.size();i++){
            ss << i << ".) "<< functionList[i]->print() << "\n";
        }
        return ss.str();
    }

    // Print out all metadata information from a module
    // This is an easy way to see all pieces of meta-data
    std::string printModuleMetaData() const{
        std::string s;
        llvm::raw_string_ostream ss(s);

          for(Module::const_named_metadata_iterator I = m_Module->named_metadata_begin(), E = m_Module->named_metadata_end(); I != E; ++I) {
            ss << "Found MDNode:\n";
            I->dump();

                for (unsigned i = 0, e = I->getNumOperands(); i != e; ++i) {
                  Metadata *Op = I->getOperand(i);
                  if (auto *N = dyn_cast<MDNode>(Op)) {
                    ss << "  Has MDNode operand:\n  ";
                    N->dump();
                  }
                }
          }

          return ss.str();
    }

    // This function gets all of the function meta-data
    void getFunctionMetaData(Function &F){
        // Store the meta-data for an individual instruction
        SmallVector< std::pair<unsigned, MDNode*>, 4> MDForInstr;
        // Iterate through each of the basic blocks in the function
       for(Function::iterator bb = F.begin(), E = F.end(); bb != E; ++bb){
            // Iterate through each instruction in our basic block
            for(BasicBlock::iterator it = bb->begin(), ie = bb->end(); it!=ie; ++it){
 /*                // Get the Metadata declare in the llvm intrinsic function
                if(CallInst* CI = dyn_cast<CallInst>(it)){
                    // ^ Above we checked if a call instruction is made, and now we create a function F for it
                    if(Function *F = CI->getCalledFunction()){
                        if(F->getName().startswith("llvm.")){
                            // Figure out how much metadata our instruction has
                            unsigned operandCount = it->getNumOperands();
                            // Finally search through all of the operands and if it non-null
                            // then create a meta-data node for it
                            // Push all of the operands that are MDNodes into meta data slots
                            for(unsigned int i =0, e = operandCount; i != e; ++i){

                                if(MDNode* N = dyn_cast_or_null<MDNode>(it->getOperand(i))){
                                    createMetadataSlot(N);
                                }
                            }
                        }
                    }
                }
*/
// ! Need to figure out exactly how this is working
                // Get all of the meta data nodes attached to each instruction
                it->getAllMetadata(MDForInstr);
                for(unsigned i = 0, e = MDForInstr.size(); i!=e; ++i){
//                    createMetadataSlot(MDForInstr[i].second);
                }
                MDForInstr.clear();

            }   // for(BasicBlock::iterator it = bb->begin(), ie = bb->end(); it!=ie; ++it){
        }       // for(Function::iterator bb = F.begin(), E = F.end(); bb != E; ++bb){
    }           // void getFunctionMetaData(Function &F){

/*
    // Map for MDNodes
    DenseMap<MDNode*,unsigned> _metadataMap;

    //
    void createMetadataSlot(MDNode *N){
            if(!N->isFunctionLocal()){
                mdn_iterator I = _metadataMap.find(N);
                if(I!=_mdnMap.end()){
                    return;
                }
                //the map also stores the number of each metadata node. It is the same order as in the dumped bc file.
                unsigned DestSlot = _mdnNext++;
                _metadataMap[N] = DestSlot;
            }

            for (unsigned i = 0, e = N->getNumOperands(); i!=e; ++i){
                if(MDNode *Op = dyn_cast_or_null<MDNode>(N->getOperand(i))){
                    createMetadataSlot(Op);
                }
            }

    }

*/


    // Takes an instruction and returns all attributes
    // TODO: Implement this on an instruction or basic block(bb) level.
    std::string returnAttributes(Instruction& i){
        return "";
    }

    // Takes an instruction and returns all Intrinsics
    // TODO: Implement this on an instruction or basic block(bb) level.
    std::string returnIntrinsics(Instruction& i){
        return "";
    }



    // This function generates random attributes for functions
    std::string attributes(llvm::Module &M){
        std::string s;
        llvm::raw_string_ostream ss(s);

        // Search llvm.global.annotations for async tasks
        auto global_annos = M.getNamedGlobal("llvm.global.annotations");
        if(global_annos){
            auto a = cast<ConstantArray>(global_annos->getOperand(0));

            for(unsigned int i =0; i < a->getNumOperands();i++){
                auto e = cast<ConstantStruct>(a->getOperand(i));
                if(auto fn = dyn_cast<Function>(e->getOperand(0)->getOperand(0))){
                    auto anno = cast<ConstantDataArray>(cast<GlobalVariable>(e->getOperand(1)->getOperand(0))->getOperand(0))->getAsCString();

                    if(anno=="async"){
                        async_fns.insert(fn);   // Can keep track of attributes here
                        ss << "FOOOOOOOOOOOOOOOOOUNNNNNNNNNNNNNNNND ASYNCCCCCCCC\n";
                    }
                    else{
                        fn->addFnAttr("myattribute");            // Can directrly add an annotation here since one did not exist
                        ss << "global anno found: " << anno << "\n";
                    }
                }
            }
        }

        Module::FunctionListType &addAttributes = M.getFunctionList();
        for(Module::FunctionListType::iterator it = addAttributes.begin(), it_end = addAttributes.end(); it != it_end; ++it){

 //       for (Function* fn : M) {
          if (it->hasFnAttribute("myattribute")) {
            ss << it->getName() << " already has my attribute!\n";
          }else{
            it->addFnAttr("myattribute");            // Can directrly add an annotation here since one did not exist
          }
        }

        Module::FunctionListType &funcsWithAttrs = M.getFunctionList();
        int function_counter = 0;
        for(Module::FunctionListType::iterator it = funcsWithAttrs.begin(), it_end = funcsWithAttrs.end(); it != it_end; ++it){
 //       for (Function* fn : M) {
          if (it->hasFnAttribute("myattribute")) {
            ss<< function_counter << ".) " << it->getName() << " has my attribute!\n";
          }
          ++function_counter;
        }

        return ss.str();
    }

    // Attempt to manually build up the callgraph
    std::string genCallGraph(Module &M){
        std::string s;
        llvm::raw_string_ostream ss(s);

        // Build up a map that has a key (which is a pair with a source and destination) and then associated meta data.
        std::map< std::pair<std::string,std::string>, std::string > edges;

        long unsigned int totalFunctionCallsInProgram = 0;

            for (Function &callerFunction : M) {                           // For each function in the module
                for (BasicBlock &bb : callerFunction) {                    // Grab its basic block
                    for (Instruction &i : bb) {
                         CallSite cs(&i);                       // Find out where the callsite of the instruction is.
                         if (!cs.getInstruction()) {
                            continue;
                         }
                         Value *called = cs.getCalledValue()->stripPointerCasts();
                         if (Function *calleeFunction = dyn_cast<Function>(called)) {
                            long unsigned int entryCount = 0;
                            if(calleeFunction->getEntryCount()){
                                entryCount = calleeFunction->getEntryCount().getValue();
                                // MDNode* meta = ("function_entry_count");
                                // MDNode *MD = calleeFunction->getMetadata("function_entry_count");
                                // ConstantInt *CI = mdconst::extract<ConstantInt>(MD->getOperand());
                                // entryCount = CI->getValue().getZExtValue();
/*                              SmallVector<std::pair<unsigned, MDNode *>,4> MDs;
                                i.getAllMetadata(MDs)
                                for(auto &MD : MDs){
                                    MDNode.get
                                }
*/
/*
                                MDNode *N = i.getMetadata("function_entry_count");
                                for(auto ops : N.operands()){
                                    operan
                                }

                                ss << "Entry count: " << entryCount << "\n";
                                totalFunctionCallsInProgram+=entryCount;
*/
                            }

                            //    Attempt to get the probability that our function will make a call to this outside function.
                            BasicBlock* src = &callerFunction.front();
                            BasicBlock* dst = &bb;
                            BranchProbabilityInfo b;
                            unsigned long int probability = b.getEdgeWeight(src, dst);

                            errs() << "Some probabilities: " << callerFunction.getName() << " (" << probability << ") " << calleeFunction->getName() << "\n";

                            // Create a pair
                            std::pair<std::string,std::string> edge = std::make_pair(callerFunction.getName(),calleeFunction->getName());
                            // Have the pair output
                            edges[edge] = std::to_string(entryCount);
                         }
                    }
                }
            }

            ss << "digraph {\n";
            // Iterate through our map and output in a digraph format
            for(std::map< std::pair<std::string,std::string>, std::string >::iterator it = edges.begin(); it!=edges.end(); it++){
                std::string edgeLabel = "[ label=\""+it->second+"\"];";
                ss << "\t\"" << it->first.first << "\" -> \"" << it->first.second << "\" " << edgeLabel << "\n";
            }
            ss << "}";

            return ss.str();
    } // end std::string genCallGraph(Module &M){


};


namespace {
  // Hello - The first implementation, without getAnalysisUsage.
  struct MyModulePass2 : public ModulePass {
    static char ID; // Pass identification, replacement for typeid
    MyModulePass2() : ModulePass(ID) {}


    bool runOnModule(Module &M) override {

            QueryCallGraph qcg(&M);
            // Used for storing and writing output
            // This seems to be more efficient than the outs()
            std::string s;
            llvm::raw_string_ostream ss(s);
            //std::vector<std::string> functionList;
            /*
              for(Module::global_iterator I = M.global_begin(), E = M.global_end(); I != E; ++I) {
                Vals.insert(&*I);
                for (User::const_op_iterator OI = I->op_begin(), OE = I->op_end(); OI != OE; ++OI)
                  Vals.insert(*OI);
              }
            */

            // (1) Prints out how many functions we have
            ss << qcg.printFunctions();

            // (2) Get function call sites
//            ss << qcg.printFunctionCallSites(M);




        // Print out the attributes that we find.
 //       ss << qcg.attributes(M);

        ss << "==========Call Graph output==========\n\n";
  //      ss << qcg.genCallGraph(M);

 //       ss << qcg.printModuleMetaData(M);
 //       ss << qcg.printFunctionMetaData(M);

        // Iterate through all functions and get their meta-data
        for (Function &fun : M) {
//            ss << qcg.printAttributes(fun);
        }
        // Just perform one write
        errs() << ss.str();


      return false;
    }




  };
}

char MyModulePass2::ID = 0;
static RegisterPass<MyModulePass2> X("mymodulepass2", "A first pass we've created");
