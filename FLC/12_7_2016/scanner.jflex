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
/*Even number ofchar at least 4 or odd number of char at least 5 followd by binary from 110 - 10101 */
token1	= "?"(([a-z]{2}([a-z]{2})+)|([A-Z]{3}([A-Z]{2})+))({bin})?
bin= 110 | 111 | 1(0|1){3} | 10000 | 10001 | 10010 | 10011 | 10100 | 10101

/* TOKEN2 regular expression */
/* word  composed of 3 or 6 repetitions of the strings “ij”, “ji”, “ii” and “jj” in any combination.*/
token2 = {word}
word = {ij}("+"|"-"){ij}(("+"|"-"){ij}("+"|"-"){ij})*
ij= ("ij"|"ii"|"jj"|"ji"){3} |("ij"|"ii"|"jj"|"ji"){6}

/* TOKEN 3 */
/*range between 2016/05/28 and 2016/08/15, with the exclusion of the day 2016/06/24*/
day31=0[1-9]|[1-2][0-9]|3[0-1]
month_day=(07)"/"{day31}|05"/"(2[8-9]|3[0-1])|06"/"(0[1-9]|[1-2][0-9]|30)|08"/"(0[1-9]|1[0-5])
year=2016
date={year}"/"{month_day}

uint = [0-9]| [1-9][0-9]*
var = [a-zA-Z][a-zA-Z0-9]*
                
sep		= "##"
comment     = "/*" ~ "*/"

%%

{sep}			{ return sym(sym.SEP); }
{token1}			{ return sym(sym.TOKEN1); }
{token2}			{ return sym(sym.TOKEN2); }
{date}			{ return sym(sym.DATE); }
";"                 { return sym(sym.S); }
"="                 { return sym(sym.EQ); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"-"				{ return sym(sym.MINUS); }
"+"				{ return sym(sym.PLUS); }
"*"                 { return sym(sym.STAR); }
"/"                 { return sym(sym.DIV); }
":"                 { return sym(sym.C); }
"{"                 { return sym(sym.BO); }
"}"                 { return sym(sym.BC); }
","                 { return sym(sym.CM); }
"stat"			{ return sym(sym.STAT); }
"case"			{ return sym(sym.CASE); }
"switch"			{ return sym(sym.SWITCH); }
"print"			{ return sym(sym.PRINT); }
"MIN"			{ return sym(sym.MIN); }
"MAX"			{ return sym(sym.MAX); }
{var}			{ return sym(sym.VAR, yytext()); }
{uint}			{ return sym(sym.UINT, new Integer(yytext())); }

{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
