Objectives
 
Implement an LLVM bitcode generator for a simple programming language.
Gain experience reading and interpreting a language specification.
Gain experience implementing a simple programming language using parser generators: Flex & Bison.

Description
In this project, we will implement an expression language, called P1 for convenience. The P1 language is designed to make bitwise processing easier than it is in C.  For example, we can make a variable equal to a bit of another variable just by specifying the bit number at the end of the variable name:

in none
x = 5  // x2=1, x1=0, x0=1
y = x2 // set y to the third bit (index of 2) of variable x
final y // y = 1
Or, we can re-arrange the bits of a number and insert an extra bit:

in none
x = 15             //x3=1,x2=1,x1=1,x0=1
y = x3,x2,0,x1,x0  // now y = 27
final y


The grammar for the P1 language is given by the following rules:

program: inputs statements_opt final;

inputs:   IN params_list ENDLINE
| IN NONE ENDLINE;

params_list: ID
| params_list COMMA ID;

final: FINAL ensemble endline_opt;

endline_opt: %empty | ENDLINE;            

statements_opt: %empty
            | statements;

statements:   statement 
            | statements statement ;

statement: ID ASSIGN ensemble ENDLINE
  /* Next two rules for 566 only */
| ID NUMBER ASSIGN ensemble ENDLINE
| ID LBRACKET ensemble RBRACKET ASSIGN ensemble ENDLINE;

ensemble:  expr
| expr COLON NUMBER // 566 only
| ensemble COMMA expr
| ensemble COMMA expr COLON NUMBER; //566 only

expr:   ID
| ID NUMBER
| NUMBER
| expr PLUS expr   // addition
| expr MINUS expr  // subtraction
| expr XOR expr    // bitwise-XOR
| expr AND expr    // bitwise-AND
| expr OR expr     // bitwise-OR
| INV expr         // bitwise-invert
| BINV expr        // least-significant bit invert
| expr MUL expr    // multiply
| expr DIV expr    // divide
| expr MOD expr    // modulo
| ID LBRACKET ensemble RBRACKET
| LPAREN ensemble RPAREN
| LPAREN ensemble RPAREN LBRACKET ensemble RBRACKET
| REDUCE AND LPAREN ensemble RPAREN
| REDUCE OR LPAREN ensemble RPAREN
| REDUCE XOR LPAREN ensemble RPAREN
| REDUCE PLUS LPAREN ensemble RPAREN
| EXPAND  LPAREN ensemble RPAREN;


