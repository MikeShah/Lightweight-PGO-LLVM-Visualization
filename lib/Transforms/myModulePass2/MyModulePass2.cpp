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

// File input/output
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/raw_ostream.h"
#include <fstream> // FIXME: Remove this eventually

// Used for Control Flow Graph of SCC's
#include "llvm/ADT/SCCIterator.h"
#include "llvm/ADT/SmallVector.h"

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

class myControlFlowGraph{
public:
    myControlFlowGraph(){}
    ~myControlFlowGraph(){}
};

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
    // Store the Control Flow Graph
    // Note that items are stored in a topological order (reverse post-order)
    SmallVector< std::pair<unsigned, MDNode*>, 4> MDForFunction;


    // Prints out all of the functions and their associated metadata
    void storeMetaData(){
        std::string s;
        llvm::raw_string_ostream ss(s);
        // Check to see if we have any meta-data in the first place.
        if(m_function->hasMetadata()){
                //for(Function::iterator bb = mi.begin(), E = mi.end(); bb != E; ++bb){
                SmallVector< std::pair<unsigned, MDNode*>, 4> MDForFunction;

                m_function->getAllMetadata(MDForFunction);
                // Iterate through all of the meta-data nodes in the function.
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
        else{
            // Print something like "meta-data: none"
        }
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
                    returnMetaData(i);
                 }
            }
        }

    }

    // Takes an instruction and returns all
    // of the meta-data from it
    std::string returnMetaData(Instruction& i){
        std::string s;
        llvm::raw_string_ostream ss(s);

        if(MDNode* N = i.getMetadata("dbg")){

//            Context c = i.getContext();
            N->dump();
            N->print(ss);
/*            DILocation Loc = i.getDebugLoc();
            //DILocation()

            unsigned Line = Loc.getLineNumber();
            StringRef File = Loc.getFilename();
            StringRef Dir = Loc.getDirectory();
            */
            ss << "meta-data not working yet";
            return ss.str();
        }
        else{
            return "";
        }

    }

    // This stores all of the attributes of an LLVM Function in a vector
    void storeAttributes(){
        AttributeSet attrs = m_function->getAttributes();

        for(unsigned i =0; i < attrs.getNumSlots(); ++i){
            if( attrs.getAsString(i,true)=="" || attrs.getAsString(i,true)==" " ){
            }
            else{
                m_attributes.push_back(attrs.getAsString(i,true));
            }
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

    // This function gets all of the function meta-data
    // TODO: Get rid of parameter (replace &F with m_function)
    void getFunctionMetaData(Function &F){
        // Store the meta-data for an individual instruction
        //SmallVector< std::pair<unsigned, MDNode*>, 4> MDForInstr;

        // Iterate through all of the results
        //for(SmallVector< std::pair<unsigned, MDNode*>, 4>::iterator sv_b = MDForFunction.begin(), sv_e = MDForFunction.end(); sv_b != sv_e; ++sv_b){

        //}

       for(Function::iterator bb = F.begin(), E = F.end(); bb != E; ++bb){
            // Iterate through each instruction in our basic block
            for(BasicBlock::iterator it = bb->begin(), ie = bb->end(); it!=ie; ++it){
                // Check if any meta-data exists on the basic block
                if(it->hasMetadata()){
                    // Get the meta-data node
                    //MDNode* md = it->getMetadata("noalias"); // Example: of getting a specific type of metadata
                    // Store all of the metadata from an instruction here
                }
 /*             // Get the Metadata declare in the llvm intrinsic function
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
//                it->getAllMetadata(MDForInstr);
//                for(unsigned i = 0, e = MDForInstr.size(); i!=e; ++i){
//                    createMetadataSlot(MDForInstr[i].second);
//                }
//               MDForInstr.clear();

            }   // for(BasicBlock::iterator it = bb->begin(), ie = bb->end(); it!=ie; ++it){
        }       // for(Function::iterator bb = F.begin(), E = F.end(); bb != E; ++bb){
    }           // void getFunctionMetaData(Function &F){


    // TODO: Implement this
    // Storing the intrinsics is interesting, because then we can see what
    // may alias(things like memcpy
    void storeIntrinsics(){

    }
    // TODO: Implement this
    //
    // Code from: http://eli.thegreenplace.net/2013/09/16/analyzing-function-cfgs-with-llvm
    // Dependency: llvm/ADT?SCCITerator.h
    void storeFunctionControlFlowGraph(){

    }

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

    // Called from Constructors to gather data about functions.
    // Ideally, we could have different implementations of this
    // if we want to run a faster or more lightweight setup.
    //
    // Essentially what this function does is calls every private function
    // that gathers data for this function.
    void init(){
        storeArguments();
        storeMetaData();
        storeFunctionCallSites();
        storeAttributes();
        storeOpCodes();
        storeIntrinsics();
        storeFunctionControlFlowGraph();
    }
public:
    // Constructor
    FunctionData(Function* F){
        m_function = F;
        init();
    }

    // Destructor
    ~FunctionData(){
    }

    // Get the llvm::Function that is stored in Function Data
    llvm::Function* getFunction(){
        return m_function;
    }

    // Get a pointer to all of our call sites
    // in a readonly fashion
    std::vector<std::pair<std::string,unsigned long int>>* getCallSites(){
        return &m_CallSites;
    }
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
        // Prints out the Control Flow graph of the function
        ss << "\n===Control Flow Graph===\n";
        ss << printControlFlowGraph();

        return ss.str();
    }

    // Returns a formatted string with the function call sites
    std::string printCallSites(){
        std::string s="";
        llvm::raw_string_ostream ss(s);

        for(unsigned i =0; i < m_CallSites.size(); i++){
            std::pair<std::string,unsigned long int> cs = m_CallSites[i];
            ss << i << ".) "<< cs.first << "(" << cs.second << +")" << "\n";
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

    // Return our vector containing a list of all of the attributes for this function
    std::vector<std::string> getAttributes(){
        return m_attributes;
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

    // TODO: Implement this
    std::string printInstrinsics(){
        std::string s="";
        llvm::raw_string_ostream ss(s);

        return ss.str();
    }

    // Prints a formatted string that can be attached to an edge
    // This function is written based on how we want to output data.
    std::string printFormattedString(){
        std::string s="";
        llvm::raw_string_ostream ss(s);

        // Start with the attributes
        if(m_attributes.size()>0){
            ss << "{";
            ss << "Attributes";
            for(unsigned i =0; i < m_attributes.size(); i++){
                ss << "|" << m_attributes[i];
            }
            ss << "}";
        }
        // Then print out meta-data


        return ss.str();
    }

    // This function will iterate through the basic blocks of a function
    // and generate the Control Flow Graph that can be useful for doing intraprocedural analysis.
    // TODO: Implement this
    std::string printControlFlowGraph(){
        std::string s="";
        llvm::raw_string_ostream ss(s);

        // Check to make sure our function is not empty
        if(m_function && m_function->size()>0){
        // In order to build the CFG we first find the terminating block, and then build up a list of successors
        outs() << "\nSCC for " << m_function->getName() << " in post-order (need to reverse to get topological order) \n\n";

            for(scc_iterator<Function *> I = scc_begin(m_function), IE = scc_end(m_function); I != IE; ++I){
                // Store all of the BB's into a vector
                const std::vector<BasicBlock*> &SCC_BBs = *I;

                if(!SCC_BBs.empty()){
                    outs() << "SCC: ";
                    for(std::vector<BasicBlock*>::const_iterator BBI = SCC_BBs.begin(), BBIE = SCC_BBs.end(); BBI != BBIE; ++BBI){
                        outs() << (*BBI)->getName() << " ";
                    }
                    outs() << "\n";
                }
            }
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

    // Gets all of the functions in the module
    // Once we have them all, we can work with them to perform more data analysis
    void getFunctions(){
        Module::FunctionListType &functions = m_Module->getFunctionList();
        // Iterate through all of the modules functions and put them into our list as Function Data
        // When we create function data with the function, the Constructor in FunctionData will
        // run many information gathering functions on it.
        for(Module::FunctionListType::iterator it = functions.begin(), it_end = functions.end(); it != it_end; ++it){
            FunctionData* d = new FunctionData(it);
            functionList.push_back(d);
        }
    }

    // Helper Function that needs to be called from every constructor
    void init(){
    // (1) Retrieve all of the functions in our Module
        getFunctions();
    }

public:
    // Stores the functions in a list data structure
    std::vector<FunctionData*> functionList;

    // Used in the function for uniqueAttributes
    // Will also keep track of the items
    std::map<std::string, unsigned long int> uniqueAttributes;

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


    /*
        Prints out the metadata from the machine.
    */
    std::string tryToPrintModuleMetaData(){
        std::string s;
        llvm::raw_string_ostream ss(s);

        // Iterate through each function
        for(unsigned i = 0; i < functionList.size(); ++i){
            Function* F = functionList[i]->getFunction();

            // Iterate through each of the basic blocks in that function.
               for(Function::iterator bb = F->begin(), E = F->end(); bb != E; ++bb){
                    // Iterate through each instruction in our basic block
                        for(BasicBlock::iterator it = bb->begin(), ie = bb->end(); it!=ie; ++it){
                        SmallVector< std::pair<unsigned, MDNode*>, 4> MDForInst;
                        it->getAllMetadata(MDForInst);
                            // Check if any meta-data exists on the basic block
                            if(it->hasMetadata()){
                                // Get the meta-data node
                                // Output all of the kinds of metadata found within our module
                                SmallVector<StringRef, 8> Names;
                                m_Module->getMDKindNames(Names);

                                for(SmallVector<std::pair<unsigned, MDNode*>, 4>::iterator II = MDForInst.begin(), EE = MDForInst.end(); II != EE; ++II) {
                                    MDNode* md = II->second;    // The actual metadata node.
                                    ss << "name: " << Names[II->first] << "Value:" << "tbd from md" <<"\n";
                                }
                            }
                        }
                }


                SmallVector< std::pair<unsigned, MDNode*>, 4> MDForFunction;
                F->getAllMetadata(MDForFunction);
                if(MDForFunction.size() > 0 ){
                    ss << "Function: " << F->getName() << "\n";
                    ss << "# of metaData" << MDForFunction.size() << "\n";
                    for(unsigned j =0; j < MDForFunction.size(); j++){
                        ss << MDForFunction[j].first << "" << MDForFunction[j].second << "\n";
                    }
                }
        }
        return ss.str();
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
 //     typedef std::map< std::pair<std::string,std::string>, std::string > edgeMap;
        std::string s;
        llvm::raw_string_ostream ss(s);

        // Build up a map that has a key (which is a pair with a source and destination) and then associated meta data.
//        edgeMap edges;
/*
//        long unsigned int totalFunctionCallsInProgram = 0;
            // For each function in the module
 //           for(Function::iterator callerFunction = m_Module->begin(), ie = m_Module->end(); callerFunction!=ie; ++callerFunction ){
            for (Function &callerFunction : M) {
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
/*                            }

                            //    Attempt to get the probability that our function will make a call to this outside function.
                            BasicBlock* src = &callerFunction.front();
                            BasicBlock* dst = &bb;
                            BranchProbabilityInfo b;
                            unsigned long int probability = b.getEdgeWeight(src, dst);  // Returns an enum for the probability of taking an edge.

                            // MIght need to use a MachineBasicBlock where mulitple MBB can map to a BB.
                            // However, we can use MBB.getBasicBlock() to map back to it b.getEdgeProbability.


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
            for(edgeMap::iterator it = edges.begin(); it!=edges.end(); it++){
                std::string edgeLabel = "[ label=\""+it->second+"\"];";
                ss << "\t\"" << it->first.first << "\" -> \"" << it->first.second << "\" " << edgeLabel << "\n";
            }
            ss << "}";
*/

        ss << "digraph {\n";
        ss << "node [shape=record];\n";
        // First print out all of the formatted nodes to the dot file
        // This is where all of the information is held.
        for(unsigned i =0; i < functionList.size(); ++i){
            llvm::Function* callerFunction = functionList[i]->getFunction();

            ss << "\"" << callerFunction->getName() << "\"" << "[shape=record,label=\""+callerFunction->getName()+"|"+functionList[i]->printFormattedString()+"\"];\n";
        }

        // Iterate through all of our functions
        for(unsigned i =0; i < functionList.size(); ++i){
            // TODO: Remove me -- Retrieve a function from our function list
            llvm::Function* callerFunction = functionList[i]->getFunction();
            // From each function, we will need to get all of its callers
            // Store these in cs
            std::vector<std::pair<std::string,unsigned long int>>* cs = functionList[i]->getCallSites();

            for(unsigned j = 0; j < cs->size(); ++j){
                std::pair<std::string,unsigned long int> cs_pair = cs->at(j);

                std::string occurrences = std::to_string(cs_pair.second);
                // Build a meta-data string that has some information
                std::string edgeLabel = "[ label=\"" + occurrences + "\"];";
                ss << "\"" << callerFunction->getName() << "\"" << " -> " << "\"" << cs_pair.first << "\"" << edgeLabel << "\n";
            }
        }
        ss << "}";

        return ss.str();
    } // end std::string genCallGraph(Module &M){

    // Store all of the unique attributes that we find.
    // When we are getting individual attributes from the functions,
    // we iterate through the attributes and add them to this filter.
    // This allows us to know what we can filter by if we pass this function data to
    // a GUI
    std::string genUniqueAttributes(){
        std::string s;
        llvm::raw_string_ostream ss(s);

        // Build a set of unique attributes
        for(unsigned i =0; i < functionList.size(); ++i){
            // Get our attributes from the function as a string
            std::vector<std::string> func_attributes = functionList[i]->getAttributes();

            // For each of the function attributes
            for(unsigned j = 0; j < func_attributes.size(); ++j){
                // Populate our map with the different attributes found in our functions
                if(uniqueAttributes.find(func_attributes[j])==uniqueAttributes.end()){
                    uniqueAttributes[func_attributes[j]] = 1;    // Add attribute to our map if it does not exist
                }else{
                    uniqueAttributes[func_attributes[j]] += 1;   // Increment the number of occurrences of the attribute
                }
            }
        }

        // TODO: Make this process more efficient (sorting a set for output). It's unlikely this is a bottleneck, but could be improved.
        // TODO: Suggested to possibly have some filter on this
        // Output all of the attributes into a vector
        for(std::map<std::string, unsigned long int>::iterator i = uniqueAttributes.begin(), ie = uniqueAttributes.end(); i != ie; ++i){
            ss << i->first << "  (" << i->second << ")\n";
        }

        return ss.str();
    }

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

            /*
              for(Module::global_iterator I = M.global_begin(), E = M.global_end(); I != E; ++I) {
                Vals.insert(&*I);
                for (User::const_op_iterator OI = I->op_begin(), OE = I->op_end(); OI != OE; ++OI)
                  Vals.insert(*OI);
              }
            */


            // Temporary dump of everything about our functions to a text file
            // FIXME: Change this to raw_ostream per llvm standards: http://llvm.org/docs/CodingStandards.html#use-raw-ostream
              std::fstream myfile;
              myfile.open (".//fullDump.txt", std::fstream::out);
              myfile << qcg.printFunctions();
              myfile.close();
            // FIXME: Change this to raw_ostream per llvm standards: http://llvm.org/docs/CodingStandards.html#use-raw-ostream
              myfile.open (".//fullDot.dot", std::fstream::out);
              myfile << qcg.genCallGraph(M);
              myfile.close();
            // FIXME: Change this to raw_ostream
              myfile.open (".//attributes.txt", std::fstream::out);
              myfile << qcg.genUniqueAttributes();
              myfile.close();

              myfile.open(".//metadata.txt",std::fstream::out);
              myfile << qcg.tryToPrintModuleMetaData();
              myfile.close();

              // Output all of the kinds of metadata found
              SmallVector<StringRef, 8> Names;
              M.getMDKindNames(Names);

/*              for(SmallVector<std::pair<unsigned, MDNode*>, 4>::iterator II = MDForInst.begin(), EE = MDForInst.end(); II != EE; ++II) {
                outs() << "name: " << Names[II->first] << "\n";
              }
*/

        // Just perform one write
        errs() << ss.str();

      return false;
    }




  };
}

char MyModulePass2::ID = 0;
static RegisterPass<MyModulePass2> X("mymodulepass2", "A first pass we've created");
