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

token={even_number}((("?"|"$"){5}("?"|"$")*)| ([A-Za-z]{4}|[A-Za-z]{6}|[A-Za-z]{9}) )

even_number= ("-"(2[024]|1[02468]|[02468]))|([02468]|[1-9][02468]|[1-9][0-9][02468]|1[1-9][0-9][02468]|2[1-3][1-9][02468]|24[1-6][02468]|247[02])



/* TOKEN 2 */

// from 2015/12/6 to 2016/3/31 with feb of 29 days
date = (2015"/"12"/"([6-9]|1[0-9]|2[0-9]|30|31)|2016"/"01"/"(0[1-9]|1[0-9]|2[0-9]|3[01])|2016"/"02"/"(0[1-9]|1[0-9]|2[0-9])|2016"/"03"/"(0[1-9]|1[0-9]|2[0-9]|3[01]))(":"{time})?

//“:HH:MM” between 04:32 and 15:47.
time = (04":"(3[2-9]|[4-5][0-9]))|((0[5-9])|(1[0-4])":"([0-5][0-9]))|(15":"([0-3][0-9])|(4[0-7]))

int =  [0-9] |[1-9][0-9]*
name = [a-zA-Z]+[0-9]*
                
sep		= ("%%%%"("%%")*) | ("#"("##")+)
comment     = \/\/.*  // comment c++ style "//"

%%

{sep}			{ return sym(sym.SEP); }
{token}			{ return sym(sym.TOKEN); }
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
"."				{ return sym(sym.DOT); }
"START"			{ return sym(sym.START); }
"MOVE"			{ return sym(sym.MOVE); }
"VAR"			{ return sym(sym.VAR); }
"WHEN"			{ return sym(sym.WHEN); }
"DONE"			{ return sym(sym.DONE); }
"THEN"			{ return sym(sym.THEN); }
"NOT"			{ return sym(sym.NOT); }
"AND"			{ return sym(sym.AND); }
"OR"				{ return sym(sym.OR); }
"!="                { return sym(sym.NOTEQ); }
"=="                { return sym(sym.EQEQ); }
{name}			{ return sym(sym.NAME, yytext()); }
{int}			{ return sym(sym.INT, new Integer(yytext())); }

{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
