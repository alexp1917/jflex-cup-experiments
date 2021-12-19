package jflex.cup.experiments;

import parser.SimpleLexer;
import parser.Yytoken;

import java.io.IOException;
import java.io.StringReader;


public class Library {
    public static void main(String[] args) throws IOException {
        SimpleLexer myLexer = new SimpleLexer(new StringReader("abc(e,f,a) + 1234"));
        while (!myLexer.yyatEOF()) {
            Yytoken yylex = myLexer.yylex();
            String text = myLexer.yytext();

            System.out.println(text);
        }
        myLexer.yyclose();
    }
}
