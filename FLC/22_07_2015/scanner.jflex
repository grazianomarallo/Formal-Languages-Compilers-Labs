import java_cup.runtime.*;

%%

%class scanner
%unicode
%cup
%line
%column

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);

  }
%}





token1= ((11\:3[5-9])|(11\:[4-5][0-9])|(12\:[0-5][0-9])|(13\:[1-4][0-9])|(13\:5[01]))|((11\:3[5-9])|(11\:[4-5][0-9])|(12\:[0-5][0-9])("am"))|(((01\:[0-4][0-9])|(01\:5[01]))("pm"))

token2={string}":"{ip}
string="\"" ~ "\""
token3="%"[a-zA-Z]{4}([a-zA-Z]{2})*{odd}((("****")("*")*)|("Y"("X")("XX")*"Y"))?

neg=[13579]|[1-2][13579]|3[135]
pos=[13579]|[1-9][13579]|1[0-9][13579]|2(0[13579]|[1-4][13579]|5[13])

odd="-"{neg}|{pos}

ip_num		=	(2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])
ip		=	{ip_num}"."{ip_num}"."{ip_num}"."{ip_num}
var=[_a-z][_a-z0-9]*

comment     = "/*" ~ "*/"
sep		= "##"("#")*

uint=[0-9]+
nint=\-[0-9]+
nl = \r|\n|\r\n
ws = [ \t]

%%

{token1}                       { return new Symbol(sym.TOKEN1); }
{token2}                       { return new Symbol(sym.TOKEN2); }
{token3}                       { return new Symbol(sym.TOKEN3); }

{sep}                        { return new Symbol(sym.SEP); }

// Section 1
{string}               { return new Symbol(sym.STR, yytext()); }
{uint}              { return new Symbol(sym.INT, new Integer(yytext())); }
{nint}              { return new Symbol(sym.NINT, new Integer(yytext())); }
"o"                 { return new Symbol(sym.O); }
{var}               { return new Symbol(sym.VAR, yytext()); }
"EVALUATE"          { return new Symbol(sym.EVALUATE); }
"CASE_TRUE"         { return new Symbol(sym.CASE_TRUE); }
"CASE_FALSE"        { return new Symbol(sym.CASE_FALSE); }
"SAVE"              { return new Symbol(sym.SAVE); }

// General stuff

","         { return new Symbol(sym.CM); }
";"         { return new Symbol(sym.S); }
":"         { return new Symbol(sym.C); }
"("         { return new Symbol(sym.RO); }
")"         { return new Symbol(sym.RC); }
"["         { return new Symbol(sym.SO); }
"]"         { return new Symbol(sym.SC); }
"{"         { return new Symbol(sym.BO); }
"}"         { return new Symbol(sym.BC); }
"."         { return new Symbol(sym.DOT); }
"="         { return new Symbol(sym.EQ); }
"=="        { return new Symbol(sym.EQEQ); }
"+"         { return new Symbol(sym.PLUS); }
"*"         { return new Symbol(sym.STAR); }
"!"         { return new Symbol(sym.NOT); }
"&&"        { return new Symbol(sym.AND); }
"||"        { return new Symbol(sym.OR); }
"TRUE"      { return new Symbol(sym.TRUE); }
"FALSE"     { return new Symbol(sym.FALSE); }

"/*" ~ "*/" { /* IGNORE */ }
{comment}	 				{;}
{ws}|{nl}   { /* IGNORE */ }
