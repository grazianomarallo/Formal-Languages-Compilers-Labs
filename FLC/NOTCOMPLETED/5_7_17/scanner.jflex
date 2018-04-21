import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column
%class scanner

%{
	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	
	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
	
%}

/* TOKEN1 regular expression */
token1	=	{even_number}([a-z]{5}([a-z]{2})*)?[ABC]|("XX"|"XY"|"YX"|"YY"){3}("xx"|"xy"|"yx"|"yy")*
even_number	= "-"(12[024] | 11[02468] | 10[02468] | [1-9][02468]) | [02468] | [0-7][02468] | 8[0246]

/* TOKEN2 regular expression */
token2	= {binary}"*|-"{binary}"*|-"{binary}"*|-"{binary}"*|-"{binary}("*|-"{binary}"*|-"{binary})*
token3= {hour}

hour = (08":"12":"(3[4-9] | [4-5][0-9]) | 08":"1[3-9]":"[0-5][0-9] | 08":"[2-5][0-9]":"[0-5][0-9] |09":"[0-5][0-9]":"[0-5][0-9]| 1[0-6]":"[0-5][0-9]":"[0-5][0-9] | 17":"[0-1][0-9]":"[0-5][0-9] | 17":"21":"[0-3][0-6] |  17":"21":"37)";"

binary = 1[0-1]{3}|10|11|110|111|1[0-1]{4}|11110
int = "+|-"0-9] | [1-9][0-9]*
name = [a-zA-Z]+[0-9]*
                
sep		= "$$"
comment     = \%.*

%%

{token1}			{ return sym(sym.TOKEN1);}
{token2}			{ return sym(sym.TOKEN2);}
{token3}			{ return sym(sym.TOKEN3);}
{int}				{ return sym(sym.INT, new Integer(yytext())); }
{sep}				{ return sym(sym.SEP); }
"-"					{ return sym(sym.MINUS); }
"+"					{ return sym(sym.PLUS); }
";"                	 { return sym(sym.S); }
":"                	 { return sym(sym.C); }
"."                	 { return sym(sym.DOT); }
","                	 { return sym(sym.CM); }
"{"                	{ return sym(sym.BO); }
"}"                	 { return sym(sym.BC); }
"("                	{ return sym(sym.RO); }
")"                	 { return sym(sym.RC); }
"X"			 { return sym(sym.X); }
"Y"			 { return sym(sym.Y); }
"F"			 { return sym(sym.F); }
"fuel"				{ return sym(sym.FUEL); }
"set position"			{ return sym(sym.POSITION); }
"declare"				{ return sym(sym.DECLARE); }
"else"				{ return sym(sym.ELSE); }
"fuel increases"		{ return sym(sym.FINCREASE); }
"fuel decreases"		{ return sym(sym.FDECREASE); }
"min" 				{ return sym(sym.MIN); }
"max" 				{ return sym(sym.MAX); }
"mv"				{ return sym(sym.MOVE); }
"NOT"				{ return sym(sym.NOT); }
"AND"				{ return sym(sym.AND); }
"OR"				{ return sym(sym.OR); }
"!="                { return sym(sym.NOTEQ); }
"=="                { return sym(sym.EQEQ); }
"="                { return sym(sym.EQ); }
"?"			{ return sym(sym.EM); }
{name}				{ return sym(sym.NAME, yytext()); }

{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
