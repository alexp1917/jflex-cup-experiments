package jflex.cup.experiments;

import parser.Yylex;
import parser.Yytoken;

import java.io.IOException;
import java.io.StringReader;


public class Library {
    public static void main(String[] args) throws IOException {
        Yylex lexer = new Yylex(new StringReader("abc(e,f,a) + 1234"));
        while (!lexer.yyatEOF()) {
            Yytoken yylex = lexer.yylex();
            String text = lexer.yytext();

            System.out.println(text);
        }
        lexer.yyclose();
    }
}
