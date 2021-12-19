package parser;
import java_cup.runtime.*;
import jflex.core.sym;

/*
    written to match http://www2.cs.tum.edu/projects/cup/
*/

%%

%public

%{
%}

%line
%char
%state COMMENT
%unicode
%class ExpressionsLexer

%debug

SEMI=;
PLUS=\+
MINUS=-
TIMES=[*x]
LPAREN=\(
RPAREN=\)
NUMBER=[0-9]
//WHITESPACE=[\s]

%%

<YYINITIAL> {
    /*
        I realized that i need to return a symbol here.

        However, that symbol means i lose my original line and
        char number. which is an unacceptable tradeoff.

        going to investigate ANTLR instead
    */
    {SEMI} { return new Symbol(1, yytext()); }
    {PLUS} { return new Symbol(); }
    {MINUS} { return new Symbol(); }
    {TIMES} { return new Symbol(); }
    {LPAREN} { return new Symbol(); }
    {RPAREN} { return new Symbol(); }
    {NUMBER} { return new Symbol(); }

    . { return new Symbol(sym.WHITESPACECLASS); }
}
