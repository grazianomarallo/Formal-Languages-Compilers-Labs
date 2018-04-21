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


token1= {word}{word2}{even}?
     
word=   ("#"|"*"|"&"){6}(("#"|"*"|"&"){2})* 
word2=[a-zA-Z0-9]+[a-zA-Z]{2}  
neg=[2468]|1[02468]|2[024]
pos=[02468]|[1-9][02468]|[1-9][0-9][02468]|1(00([02468])|0([1-9][02468])|1[0-9][02468]|2(0[02468]|[1-4][02468]|5[02468]))
even="-"{neg}|{pos}


token2=  ({hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex})|
	   ({hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"))
	   |({hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}  ("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex}("-"|":"){hex})

hex= [0-9a-fA-F]{3} |  [0-9a-fA-F]{5}

token3={hour}

//parenthesis () instead of [] in 1[0-6] and 1[0-2]
hour= {normal}|{am}|{pm}
normal=(09":"3[1-9])|(09":"([4-5][0-9]))|(09":"([0-5][0-9]))|(1[0-6]":"([0-5][0-9]))|(17":"([1-3][0-9]))|(17":"4[0-6])
am= ((09":"3[1-9])|(09":"[4-5][0-9])|(09":"[0-5][0-9])|(1[0-2]":"[0-5][0-9]))("am")
pm= ((05":"[0-3][0-9])|(05":"4[0-6])|(0(1-4)":"[0-5][0-9]))("pm")
 
id=[a-zA-Z_][a-zA-Z0-9_]*
double = ([0-9]*[.])?[0-9]*		// + instead of * on the last [0-9]
//QUOTED STRING
quote="\"" ~ "\""
sep		= "$$$"
comment     = "/*" ~ "*/"

%%

{sep}			{ return sym(sym.SEP); }
{token1}			{ return sym(sym.TOKEN1); }
{token2}			{ return sym(sym.TOKEN2); }
{token3}			{ return sym(sym.TOKEN3); }
";"                	 { return sym(sym.S); }
"="               	 { return sym(sym.EQ); }
"("               	  { return sym(sym.RO); }
")"               	  { return sym(sym.RC); }
"-"				{ return sym(sym.MINUS); }
"+"				{ return sym(sym.PLUS); }
"*"                 { return sym(sym.STAR); }
"/"                 { return sym(sym.DIV); }
":"                 { return sym(sym.C); }
"["                 { return sym(sym.SO); }
"]"                 { return sym(sym.SC); }
","                 { return sym(sym.CM); }
"FZ"			{ return sym(sym.FZ); }
"IF"			{ return sym(sym.IF); }
"PATH"			{ return sym(sym.PATH); }
"MAX"			{ return sym(sym.MAX); }
"IN RANGE"			{ return sym(sym.INRANGE); }
"PRINT"			{ return sym(sym.PRINT); }
{id}				{ return sym(sym.ID, yytext()); }
{quote}				{ return sym(sym.QUOTE, yytext()); }
{double}				{ return sym(sym.FLOAT, new Double (yytext())); }
{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
