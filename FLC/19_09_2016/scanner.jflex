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
token	=	{odd}([A-Z]{4}([A-Z])*)?("***"|{strings})
strings = ("xx" | "xy" | "yx" | "yy"){4}("xx" | "xy" | "yx" | "yy")*
/*Odd number between -187 and 67*/
odd = "-"(18[13]|1[0-7][13579]|[0-9][13579]|[13579])|([13579]|[1-5][13579]|6[1357])

/* TOKEN 3 */
/*range between 2015/09/19 and 2016/02/15 */
date = 2015"/"(09"/"(19|2[0-9]|30)|1[0-2]"/"(0[1-9]|[12][0-9]|30)|1[02]"/"31)|2016"/"0(1"/"(0[1-9]|[12][0-9]|3[01])|2"/"(0[1-9]|1[0-5]))

//“:HH:MM” between 06:13 and 15:43.
time = ":"(0(6":"(1[3-9]|[2-5][0-9])|[7-9]":"[0-5][0-9])|1([0-4]":"[0-5][0-9]|5":"([0-3][0-9]|4[0-3])))
	

float = [+-]?([0-9]*[.])?[0-9]*

                
sep		= "%%%%"("%%")*
comment     = "/*" ~ "*/"

%%

{sep}			{ return sym(sym.SEP); }
{token}			{ return sym(sym.TOKEN); }
{date}{time}?		{ return sym(sym.DATE); }
";"                 { return sym(sym.S); }
"#"                 { return sym(sym.SHARP); }
"-"				{ return sym(sym.MINUS); }
":"                 { return sym(sym.C); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
","                 { return sym(sym.CM); }
"->"				{ return sym(sym.ARROW); }
"?"				{ return sym(sym.QM); }
"SET"			{ return sym(sym.SET); }
"POWER"			{ return sym(sym.POWER); }
"WATER"			{ return sym(sym.WATER); }
"STATE_CHANGE1"	{ return sym(sym.STC1); }
"STATE_CHANGE2"	{ return sym(sym.STC2); }
"INCREASE"		{ return sym(sym.INCREASE); }
"DECREASE"		{ return sym(sym.DECREASE); }
"TRUE"			{ return sym(sym.TRUE); }
"FALSE"			{ return sym(sym.FALSE); }
"AND"			{ return sym(sym.AND); }
"OR"				{ return sym(sym.OR); }
"NOT"			{ return sym(sym.NOT); }
"AVG"			{ return sym(sym.AVG); }
"TEMP"			{ return sym(sym.TEMP); }
"ADD"			{ return sym(sym.ADD); }
"SUB"			{ return sym(sym.SUB); }
"PRESSURE"		{ return sym(sym.PRESSURE); }

{float}			{ return sym(sym.FLOAT, new Double (yytext())); }

{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
