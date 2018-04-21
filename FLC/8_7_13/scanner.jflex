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

// 8:35 - 17:49
/*
hour=((8\:3[5-9])|(8\:[4-5][0-9])|((9|1(0-4)\:[0-5][0-9])|(17\:[1-4][0-9])|(17\:5[01]))|((8\:3[5-9])|(9|1(0-2)\:[4-5][0-9])|("am"))|(((05\:[0-4][0-9])|(01\:5[01])|((0(1-4)\:[0-5][0-9])))("pm"))
*/
hour= {normal}|{am}|{pm}
normal=(08":"3[5-9])|(08":"([4-5][0-9]))|(09":"([0-5][0-9]))|(1(0-6)":"([0-5][0-9]))|(17":"([1-4][0-9]))|(17":"5[01])
am= ((08":"3[5-9])|(08":"[4-5][0-9])|(09":"[0-5][0-9])|(1(0-2)":"[0-5][0-9]))("am")
pm= ((05":"[0-4][0-9])|(0(1-4)":"[0-5][0-9]))("pm")

code="?"[a-z]{4}([a-z]{2})*|"?"([A-Z]{3}([A-Z]{2})*"?"(("xy"|"xx"|"yx"|"yy"){3}("xy"|"xx"|"yx"|"yy")*))?

ip_num		=	(2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])
ip		=	{ip_num}"."{ip_num}"."{ip_num}"."{ip_num} ":" {even}

neg=[246]
pos=[02468]|[1-9][02468]|1(0[02468]|1[02468]|2[02468])
even="-"{neg}|{pos}
id=[a-zA-Z_][a-zA-Z0-9_]*
int = [+-]?[0-9]|[+-]?[1-9][0-9]*

/*Separator must be 3 or more $ in an odd number*/                
sep		= "%%"

/*C style comment*/
comment     = "/*" ~ "*/"

%%


{hour}			{ return sym(sym.HOUR);}
{code}			{ return sym(sym.CODE);}
{ip}			{ return sym(sym.IP);}
";"                 { return sym(sym.S); }
"."                 { return sym(sym.DOT); }
","                 { return sym(sym.CM); }
"="                 { return sym(sym.EQ); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"{"                 { return sym(sym.BO); }
"}"                 { return sym(sym.BC); }
"=="                 { return sym(sym.EQU); }
"&&"                 { return sym(sym.AND); }
"||"                 { return sym(sym.OR); }
"!"                 { return sym(sym.NOT); }
"START"			{ return sym(sym.START); }
"STATE"			{ return sym(sym.STATE); }
"#"				{ return sym(sym.HASH); }
"IF"				{ return sym(sym.IF); }
"THEN"			{ return sym(sym.THEN); }
"ELSE"			{ return sym(sym.ELSE); }
"PRINT"			{ return sym(sym.PRINT); }
{id}				{ return sym(sym.ID, yytext()); }
{int}			{ return sym(sym.INT, new Integer(yytext())); }
{sep}			{ return sym(sym.SEP); }



{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
