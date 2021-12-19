package parser;
/* this is the scanner example from the JLex website
   (with small modifications to make it more readable) */

%%

%public

%{
  private int comment_count = 0;
%}

%line
%char
%state COMMENT
%unicode

%debug

ALPHA=[A-Za-z]
DIGIT=[0-9]
NONNEWLINE_WHITE_SPACE_CHAR=[\ \t\b\012]
NEWLINE=\r|\n|\r\n
WHITE_SPACE_CHAR=[\n\r\ \t\b\012]
STRING_TEXT=(\\\"|[^\n\r\"]|\\{WHITE_SPACE_CHAR}+\\)*
COMMENT_TEXT=([^*/\n]|[^*\n]"/"[^*\n]|[^/\n]"*"[^/\n]|"*"[^/\n]|"/"[^*\n])+
Ident = {ALPHA}({ALPHA}|{DIGIT}|_)*

%%

<YYINITIAL> {
  "," { return (new parser.Yytoken(0,yytext(),yyline,yychar,yychar+1)); }
  ":" { return (new parser.Yytoken(1,yytext(),yyline,yychar,yychar+1)); }
  ";" { return (new parser.Yytoken(2,yytext(),yyline,yychar,yychar+1)); }
  "(" { return (new parser.Yytoken(3,yytext(),yyline,yychar,yychar+1)); }
  ")" { return (new parser.Yytoken(4,yytext(),yyline,yychar,yychar+1)); }
  "[" { return (new parser.Yytoken(5,yytext(),yyline,yychar,yychar+1)); }
  "]" { return (new parser.Yytoken(6,yytext(),yyline,yychar,yychar+1)); }
  "{" { return (new parser.Yytoken(7,yytext(),yyline,yychar,yychar+1)); }
  "}" { return (new parser.Yytoken(8,yytext(),yyline,yychar,yychar+1)); }
  "." { return (new parser.Yytoken(9,yytext(),yyline,yychar,yychar+1)); }
  "+" { return (new parser.Yytoken(10,yytext(),yyline,yychar,yychar+1)); }
  "-" { return (new parser.Yytoken(11,yytext(),yyline,yychar,yychar+1)); }
  "*" { return (new parser.Yytoken(12,yytext(),yyline,yychar,yychar+1)); }
  "/" { return (new parser.Yytoken(13,yytext(),yyline,yychar,yychar+1)); }
  "=" { return (new parser.Yytoken(14,yytext(),yyline,yychar,yychar+1)); }
  "<>" { return (new parser.Yytoken(15,yytext(),yyline,yychar,yychar+2)); }
  "<"  { return (new parser.Yytoken(16,yytext(),yyline,yychar,yychar+1)); }
  "<=" { return (new parser.Yytoken(17,yytext(),yyline,yychar,yychar+2)); }
  ">"  { return (new parser.Yytoken(18,yytext(),yyline,yychar,yychar+1)); }
  ">=" { return (new parser.Yytoken(19,yytext(),yyline,yychar,yychar+2)); }
  "&"  { return (new parser.Yytoken(20,yytext(),yyline,yychar,yychar+1)); }
  "|"  { return (new parser.Yytoken(21,yytext(),yyline,yychar,yychar+1)); }
  ":=" { return (new parser.Yytoken(22,yytext(),yyline,yychar,yychar+2)); }

  {NONNEWLINE_WHITE_SPACE_CHAR}+ { }

  "/*" { yybegin(COMMENT); comment_count++; }

  \"{STRING_TEXT}\" {
    String str =  yytext().substring(1,yylength()-1);
    return (new parser.Yytoken(40,str,yyline,yychar,yychar+yylength()));
  }

  \"{STRING_TEXT} {
    String str =  yytext().substring(1,yytext().length());
    return (new parser.Yytoken(41,str,yyline,yychar,yychar + str.length()));
  }

  {DIGIT}+ { return (new parser.Yytoken(42,yytext(),yyline,yychar,
  yychar+yylength()
  )); }

  {Ident} { return (new parser.Yytoken(43,yytext(),yyline,yychar,
  yychar+yylength())); }
}

<COMMENT> {
  "/*" { comment_count++; }
  "*/" { if (--comment_count == 0) yybegin(YYINITIAL); }
  {COMMENT_TEXT} { }
}


{NEWLINE} { }

. {
  System.out.println("Illegal character: <" + yytext() + ">");
}

