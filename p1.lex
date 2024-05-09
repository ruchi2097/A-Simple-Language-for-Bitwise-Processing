%{
#include <stdio.h>
#include <math.h>
#include <cstdio>
#include <list>
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/IRBuilder.h"

#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/Support/SystemUtils.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Support/FileSystem.h"

using namespace std;
using namespace llvm;  

#include "p1.y.hpp"
#define print quiet

extern FILE *yyin;
int yylex();
void yyerror(const char*);
void quiet(const char*, ...){
}

%}


   //%option debug
%%

[ \t]         //ignore

in              { print("IN\n"); return IN; }
none            { print("NONE\n"); return NONE; }
reduce          { print("REDUCE\n"); return REDUCE; }
final           { print("FINAL\n"); return FINAL; }
expand          { print("EXPAND\n"); return EXPAND; }

[a-zA-Z]+     { 
  print("ID %s\n",yytext);
  yylval.name = strdup(yytext);
  return ID; }

[0-9]+        { 
  print("NUMBER %s\n",yytext);
  yylval.num = atoi(yytext);
  return NUMBER; }

"]"           { print("RBRACKET\n"); return RBRACKET; }
"["           { print("LBRACKET\n"); return LBRACKET; }
"("           { print("LPAREN\n"); return LPAREN; }
")"           { print("RPAREN\n"); return RPAREN; }

"="           { print("ASSIGN\n"); return ASSIGN; }
"*"           { print("MUL\n"); return MUL; }
"%"           { print("MOD\n"); return MOD; }
"/"           { print("DIV\n"); return DIV; }
"+"           { print("PLUS\n"); return PLUS; }
"-"           { print("MINUS\n"); return MINUS; }

"^"           { print("XOR\n"); return XOR; }
"|"           { print("OR\n"); return OR; }
"&"           { print("AND\n"); return AND; }

"~"           { print("INV\n"); return INV; }
"!"           { print("BINV\n"); return BINV; }


","           { print("COMMA\n"); return COMMA; }
\n            { print("ENDLINE\n"); return ENDLINE; }
:             { print("COLON\n"); return COLON; }

"//".*\n      {
		printf("syntax error!%s \n",yytext);
		exit(1);
	      }
%%

int yywrap()
{
  return 1;
}
