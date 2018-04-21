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

token= ("%"|"+"|"-"){5}(("%"|"+"|"-"){2})*{let_num}({odd})?
odd= ("-"4[3579]|[1-3][3579])|([13579]|[1-9][13579]|[1][01][13579]12[13])

let_num = [a-zA-Z]+[0-9]*[a-zA-Z]


/* TOKEN 2 */


//"HH:MM:SS” between 04:32 and 15:47.
time = (10:4[5]:(1[2-9])|[2-5][0-9])|(11:[0-5][0-9]:[0-5][0-9])|(12:[0-5][0-9]:[0-5][0-9])|(13:[0-2][0-9]:[0-1][0-9])

float = [+-]?([0-9]*[.])?[0-9]+
id = [a-zA-Z_][a-zA-Z0-9_]+
quote = "\"" ~ "\""          
 
sep		= ("****"("**")*) | ("###"("#")+)
comment  = "/*" ~ "*/"

%%

{sep}			{ return sym(sym.SEP); }
{token}			{ return sym(sym.TOKEN); }
{time}			{ return sym(sym.TIME); }
";"                 { return sym(sym.S); }
"="                 { return sym(sym.EQ); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
":"                 { return sym(sym.C); }
"["                 { return sym(sym.BO); }
"]"                 { return sym(sym.BC); }
","                 { return sym(sym.CM); }
"."				{ return sym(sym.DOT); }
">"				{ return sym(sym.GREAT); }
"<"				{ return sym(sym.SMALL); }
"Z_STATS"			{ return sym(sym.STAT); }
"WHEN"			{ return sym(sym.WHEN); }
"NOT"			{ return sym(sym.NOT); }
"AND"			{ return sym(sym.AND); }
"OR"				{ return sym(sym.OR); }
"IS"                { return sym(sym.IS); }
"x"                { return sym(sym.X); }
"y"                { return sym(sym.Y); }
"z"                { return sym(sym.Z); }
"PRINT"			{ return sym(sym.PRINT); }
"FALSE"                { return sym(sym.FALSE); }
"TRUE"                { return sym(sym.TRUE); }
{id}			{ return sym(sym.ID, yytext()); }
{float}			{ return sym(sym.NUM, new Double(yytext())); }
{quote}			{ return sym(sym.QUOTE, yytext()); }

{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
