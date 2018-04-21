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

%state not_header	
//THIS AVOID THAT CODE MATCHES WITH UINT


hour	=  ":"(08":"(3[1-9]|[4-5][0-9])({sec})?)|(09":"([0-9]|([0-5][0-9]))({sec})?)|(1[0-9]":"([0-9]|([0-5][0-9]))({sec})?)|((2[0-2])":"([0-9]|([0-5][0-9]))({sec}?))|(23":"([0-1][0-9])({sec})?)|(23":"(2[0-1]))({sec}?)

sec= (":"12|[1-5][0-9]) |(":"0[0-9])|(":"[1-5][0-9])|(":"0[0-9]|10)


/* TOKEN2 regular expression */

code = {word}?{even}
word=("X"|"Y"){3}(("X"|"Y"){2})* 
neg=[2468]|[1-9][02468]|1(0[02468]|[1-2][02468]|3[02468])
pos=[02468]|[1-9][02468]|[1-7][0-9][02468]|8(0[02468]|1[02468]|2[024])
even="-"{neg}|{pos}



/* TOKEN 3 */
/*range between 2016/05/28 and 2016/08/15, with the exclusion of the day 2016/06/24*/



string=[a-zA-Z]+
user_code=[a-zA-Z]{3}([a-zA-Z]{2})*"."{number}"."{number}("."{number}{2})*
number=1[2-9]|[2-9][0-9]|1(0[0-9]|[1-2][0-9]|3[0-2])
uint=([0-9]| [1-9][0-9]*)
currency= {uint}"."[0-9]{2}

quote="\"" ~ "\""


                
sep		= "*****"
//comment     = "/*" ~ "*/"

%%

{sep}			{ yybegin(not_header); return sym(sym.SEP); } // THIS HAS TO BE WRITTEN TO AVOID THE ABOVE MENTIONED MATCHING
{hour}			{ return sym(sym.HOUR); }
<YYINITIAL>{code}	{ return sym(sym.CODE); }



";"                 { return sym(sym.S); }
":"                 { return sym(sym.C); }
"."                 { return sym(sym.DOT); }
","                 { return sym(sym.CM); }
"Auction"			{ return sym(sym.AUC); }
"min"			{ return sym(sym.MIN); }
"->"				{ return sym(sym.ARROW); }
"euro"			{ return sym(sym.EURO); }
{string}			{ return sym(sym.STR, yytext()); }
{quote}			{ return sym(sym.QUOTE, yytext()); }
{uint}			{ return sym(sym.UINT, new Integer(yytext())); }
{currency}		{ return sym(sym.CURR, new Float(yytext())); }
{user_code}		{ return sym(sym.USC, new String (yytext())); }




//{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
