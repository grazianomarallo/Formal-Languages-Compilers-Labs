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

token= {even_number}((("$"|"?"){5}("$"|"?")*)|([a-zA-Z]{4}|[a-zA-Z]{6}|[a-zA-Z]{9}))

neg=[2468]|1[02468]|2[024]
pos=[02468]|[1-9][02468]|[1-9][0-9][02468]|1([0-9]){2}[02468]|2(00([02468])|0([1-9][02468])|[1-3][0-9][02468]|4(0[02468]|[1-6][02468]|7[02]))
even_number="-"{neg}|{pos}



/* TOKEN 2 */

// from 2015/12/6 to 2016/3/31 with feb of 29 days

date = {d}(":"{time})?
d= {date1}|{date2}
month_day1=12"/"0[6-9]|[1-2][0-9]|3[0-1]
date1=2015"/"{month_day1}

day29=0[1-9]|[1-2][0-9]
day31=0[1-9]|[1-2][0-9]|3[0-1]
month_day2=(02)"/"{day29}|(01|03)"/"{day31}
year2=2016
date2={year2}"/"{month_day2}

//:HH:MM between 04:32 and 15:47.
time = (04":"(3[2-9]|[4-5][0-9]))|((0[5-9])|(1[0-4])":"([0-5][0-9]))|(15":"([0-3][0-9])|(4[0-7]))


int =  [0-9] |[1-9][0-9]*
name = [a-zA-Z]+[0-9]*
                
sep		= (("%%%%")("%%")+)|(("#")("##")+)
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
