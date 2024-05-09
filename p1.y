%{
#include <cstdio>
#include <list>
#include <vector>
#include <map>
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"

#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/Support/SystemUtils.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/FileSystem.h"

using namespace llvm;
using namespace std;

extern FILE *yyin;
int yylex();
void yyerror(const char*);
//void quiet(const char*, ...){
//}

// Need for parser and scanner
int yyparse();
 
// Needed for LLVM
string funName;
Module *M;
LLVMContext TheContext;
IRBuilder<> Builder(TheContext);
std::unordered_map<std::string, Value*> ID_pair;
 
%}

%union {
  Value *val;
  vector<string> *params_list;
   char* name;
  int num;
}

/*%define parse.trace*/

%type <params_list> params_list
%type <val> expr
%type <val> ensemble
%token <name> ID
%token <num> NUMBER

%token IN FINAL
%token ERROR
%token BINV INV PLUS MINUS XOR AND OR MUL DIV MOD
%token COMMA ENDLINE ASSIGN LBRACKET RBRACKET LPAREN RPAREN NONE COLON
%token REDUCE EXPAND

%precedence BINV
%precedence INV
%left PLUS MINUS OR
%left MUL DIV AND XOR MOD

%start program

%%

program: inputs statements_opt final
{
  YYACCEPT;
}
;

inputs:   IN params_list ENDLINE
{  
  std::vector<Type*> param_types;
  std::vector <string> param_names;
  for(auto s: *$2)
  {
    param_types.push_back(Builder.getInt32Ty());
    param_names.push_back(s);
  }
  
  ArrayRef<Type*> Params (param_types);
  
  // Create int function type with no arguments
  FunctionType *FunType = 
    FunctionType::get(Builder.getInt32Ty(),Params,false);

  // Create a main function
  Function *Function = Function::Create(FunType,GlobalValue::ExternalLinkage,funName,M);

  int arg_no=0;
  for(auto &a: Function->args()) {
    // iterate over arguments of function
    // match name to position
    ID_pair[param_names[arg_no]]=&a;
    arg_no++;
 }
  
  //Add a basic block to main to hold instructions, and set Builder
  //to insert there
  Builder.SetInsertPoint(BasicBlock::Create(TheContext, "entry", Function));

}
| IN NONE ENDLINE
{ 
  // Create int function type with no arguments
  FunctionType *FunType = 
    FunctionType::get(Builder.getInt32Ty(),false);

  // Create a main function
  Function *Function = Function::Create(FunType,  
         GlobalValue::ExternalLinkage,funName,M);

  //Add a basic block to main to hold instructions, and set Builder
  //to insert there
  Builder.SetInsertPoint(BasicBlock::Create(TheContext, "entry", Function));
}
;

params_list: ID
{
   $$ = new vector<string>;
   $$->push_back($1);
}
| params_list COMMA ID
{
   $1->push_back($3);
}
;

final: FINAL ensemble endline_opt
{
   Builder.CreateRet($2);
}
;

endline_opt: %empty | ENDLINE;
            

statements_opt: %empty
            | statements;

statements:   statement 
            | statements statement 
;

statement: ID ASSIGN ensemble ENDLINE
{
   ID_pair[$1]=$3;

}

| ID NUMBER ASSIGN ensemble ENDLINE
{
   auto it = ID_pair.find($1);
   if (it == ID_pair.end()) {
      exit(1);
   }	
   Value *mask = Builder.getInt32(1);
   mask = Builder.CreateShl(mask, $2);
   mask = Builder.CreateNot(mask);
   Value *tmp = Builder.CreateAnd(ID_pair[$1], mask);
   Value *tmp1 = Builder.CreateAnd($4, 1);
   tmp1 = Builder.CreateShl(tmp1, $2);
   tmp1 = Builder.CreateOr(tmp, tmp1);
   ID_pair[$1] = tmp1;


}
| ID LBRACKET ensemble RBRACKET ASSIGN ensemble ENDLINE
{
    auto it = ID_pair.find($1);
    if (it == ID_pair.end()) {
      exit(1);
    }	
    Value *mask = Builder.getInt32(1);
    mask = Builder.CreateShl(mask, $3);
    mask = Builder.CreateNot(mask);
    Value *tmp = Builder.CreateAnd(ID_pair[$1], mask);
    Value *tmp1 = Builder.CreateAnd($6, 1);
    tmp1 = Builder.CreateShl(tmp1, $3);
    tmp1 = Builder.CreateOr(tmp, tmp1);
    ID_pair[$1] = tmp1;
  
}
;

ensemble:  expr
{
    $$=$1;
}
| expr COLON NUMBER                  // 566 only
{
    $$ = Builder.CreateShl($1,$3);
}
| ensemble COMMA expr
{
    $$ = Builder.CreateOr(Builder.CreateShl($1,1),$3);
    
}
| ensemble COMMA expr COLON NUMBER   // 566 only
{
   Value* tmp = Builder.CreateShl($1,Builder.getInt32(1));
   tmp = Builder.CreateShl(tmp,$5);
   $3 = Builder.CreateShl($3,$5);
   $$ = Builder.CreateOr(tmp,$3);
}
;

expr: ID
{
   auto it = ID_pair.find($1);
   if (it == ID_pair.end()) 
       $$ = Builder.getInt32(0);
   else
       $$ = ID_pair[$1];
}
| ID NUMBER
{

   $$ = Builder.CreateAnd(Builder.CreateLShr(ID_pair[$1],$2),Builder.getInt32(1));
}
| NUMBER
{
   $$ = Builder.getInt32($1);
}
| expr PLUS expr
{
   $$ = Builder.CreateAdd($1,$3);
}
| expr MINUS expr
{
   $$ = Builder.CreateSub($1,$3);
}
| expr XOR expr
{
   $$ = Builder.CreateXor($1,$3);
}
| expr AND expr
{
   $$ = Builder.CreateAnd($1,$3);
}
| expr OR expr
{
   $$ = Builder.CreateOr($1,$3);
}
| INV expr
{
   $$ = Builder.CreateNot($2);
}
| BINV expr
{
   $$ = Builder.CreateXor($2,1); 
}
| expr MUL expr
{
   $$ = Builder.CreateMul($1,$3);
}
| expr DIV expr
{
   $$ = Builder.CreateUDiv($1,$3);
}
| expr MOD expr
{
   $$ = Builder.CreateSRem($1,$3);
}
| ID LBRACKET ensemble RBRACKET
{
   $$ = Builder.CreateAnd(Builder.CreateLShr(ID_pair[$1],$3),Builder.getInt32(1));

}
| LPAREN ensemble RPAREN
{
   $$=$2;
}
/* 566 only */
| LPAREN ensemble RPAREN LBRACKET ensemble RBRACKET
{
   $$ = Builder.CreateAnd(Builder.CreateLShr($2,$5),1);
}
| REDUCE AND LPAREN ensemble RPAREN
{	
   Value *AllOne = Builder.CreateNot(Builder.getInt32(0));
   Value *comparison = Builder.CreateICmpEQ(AllOne, $4);
   Value *result = Builder.CreateSelect(comparison, Builder.getInt32(1), Builder.getInt32(0));
   $$ = result;
  
}

| REDUCE OR LPAREN ensemble RPAREN
{
   Value *AllZero = Builder.getInt32(0);
   Value *comparison = Builder.CreateICmpEQ(AllZero, $4);
   Value *result = Builder.CreateSelect(comparison, Builder.getInt32(0), Builder.getInt32(1));
   $$ = result;

}
| REDUCE XOR LPAREN ensemble RPAREN
{
  Value *reducedXor = Builder.getInt32(0);
  for(int i=0; i<32; i++)
  {
    Value *tmp = Builder.CreateAnd(Builder.CreateLShr($4, Builder.getInt32(i)), Builder.getInt32(1));
    reducedXor = Builder.CreateXor(reducedXor, tmp);
  }
  $$ = reducedXor;

}
| REDUCE PLUS LPAREN ensemble RPAREN
{

  Value *reducedPlus = Builder.getInt32(0);
  for(int i=0; i<32; i++)
  {
    Value *tmp = Builder.CreateAnd(Builder.CreateLShr($4, Builder.getInt32(i)), Builder.getInt32(1));
    reducedPlus = Builder.CreateAdd(reducedPlus, tmp);
  }
  $$ = reducedPlus;
}
| EXPAND  LPAREN ensemble RPAREN
{
 
  $$ = Builder.CreateAdd(Builder.CreateNot($3),Builder.getInt32(1));
}
;

%%

unique_ptr<Module> parseP1File(const string &InputFilename)
{
  funName = InputFilename;
  if (funName.find_last_of('/') != string::npos)
    funName = funName.substr(funName.find_last_of('/')+1);
  if (funName.find_last_of('.') != string::npos)
    funName.resize(funName.find_last_of('.'));
    
  //errs() << "Function will be called " << funName << ".\n";
  
  // unique_ptr will clean up after us, call destructor, etc.
  unique_ptr<Module> Mptr(new Module(funName.c_str(), TheContext));

  // set global module
  M = Mptr.get();
  
  /* this is the name of the file to generate, you can also use
     this string to figure out the name of the generated function */
  yyin = fopen(InputFilename.c_str(),"r");

  //yydebug = 1;
  if (yyparse() != 0)
    // errors, so discard module
    Mptr.reset();
  else
    // Dump LLVM IR to the screen for debugging
    M->print(errs(),nullptr,false,true);
  
  return Mptr;
}

void yyerror(const char* msg)
{
 printf("%s\n",msg);
}
