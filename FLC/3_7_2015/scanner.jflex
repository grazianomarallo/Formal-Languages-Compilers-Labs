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

/* code1 regular expression */
code1	="#"[a-zA-Z]{4}([a-zA-Z]{2})*{number}("IJK"|"XY"(("Z")("ZZ")*))?

neg=[1-3]
pos=[0-9]|[1-9][0-9]|1(0[0-9]|1[0-9]|2[0-3])
number="-"{neg}|{pos}


/* code2 regular expression */
code2	= {hex}(":"|"-"){hex}((":"|"-"){hex}(":"|"-"){hex})*
hex = [0-9a-fA-F]{2} | [0-9a-fA-F]{4}

uint = [0-9]| [1-9][0-9]*
float = [+-]?([0-9]*[.])?[0-9]+



/*Separator must be 3 or more $ in an odd number*/                
sep		= "$$$"("$$")*

/*C++ style comment*/
comment     = \/\/.*

%%

{code1}			{ return sym(sym.CODE1);}
{code2}			{ return sym(sym.CODE2);}
{uint}			{ return sym(sym.UINT, new Integer(yytext())); }
{float}			{ return sym(sym.FLOAT, new Float(yytext())); }
{sep}			{ return sym(sym.SEP); }
"-"				{ return sym(sym.MINUS); }
"+"				{ return sym(sym.PLUS); }
";"                 { return sym(sym.SC); }
":"                 { return sym(sym.C); }
","                 { return sym(sym.CM); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"OXYGEN"			{ return sym(sym.OX); }
"CELLS"			{ return sym(sym.CEL); }
"MOD_STATE1"		{ return sym(sym.MD1); }
"MOD_STATE2"		{ return sym(sym.MD2); }
"MAX"			{ return sym(sym.MAX); }
"TEMP"			{ return sym(sym.TEMP); }
"FOOD"			{ return sym(sym.FOOD); }


{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
