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


code= {word}"|"{hex}
hex=("-"3[13579Bb]|"-"[12]{hex_odd}|"-"?{hex_odd}|[1-9Aa-fA-F]{hex_odd}|[1-9][0-9a-fA-F]{hex_odd}|[Aa][0-9Aa]{hex_odd}|[Aa][Bb][135])?
hex_odd = [13579BbDdFf]
word= ("x"|"y"|"z"){6}(("x"|"y"|"z"){2})*

hour = 1(0":"(1(1":"(1[2-9]|[25][0-9])|[2-9]":"[0-5][0-9])|[2-5][0-9]":"[0-5][0-9])|[1-4](":"[0-5][0-9]){2}|5":"([12][0-9]":"[0-5][0-9]|3([0-5]":"[0-5][0-9]|6":"([0-3][0-9]|4[0-7]))))

number= ({bin}("."|"-"|"+"){bin}("."|"-"|"+"){bin}("."|"-"|"+"){bin})(("."|"-"|"+"){bin}("."|"-"|"+"){bin})*
bin= (1|0){3}|(1|0){15}

state_name= [A-Z_]([A-Z0-9_])
attr_name = [a-z]?
quote="\"" ~ "\""
op = {state_name}"."{attr_name}

int = (["+"|"-"]?[0-9])|(["+"|"-"]? [1-9][0-9]*)

/*Separator must be 3 or more $ in an odd number*/                
sep		= "##"
comment     = "/*" ~ "*/"

%%


{sep}			{ return sym(sym.SEP); }
";"                 { return sym(sym.S); }
":"                 { return sym(sym.C); }
","                 { return sym(sym.CM); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"["                 { return sym(sym.SO); }
"]"                 { return sym(sym.SC); }
"="				{ return sym(sym.EQ); }
"WHEN"			{ return sym(sym.WHEN); }
"!"			{ return sym(sym.NOT); }
"&&"			{ return sym(sym.AND); }
"||"				{ return sym(sym.OR); }
"=="				{ return sym(sym.EQEQ); }
"."				{ return sym(sym.DOT); }
"CASE"			{ return sym(sym.CASE); }
"PRINT"			{ return sym(sym.PRINT); }
"NEXT"			{ return sym(sym.NEXT); }
"INIT"			{ return sym(sym.INIT); }
"DEFAULT"			{ return sym(sym.DEFAULT); }
"DO"			{ return sym(sym.DO); }
"DONE"			{ return sym(sym.DONE); }
{code}			{ return sym(sym.CODE);}
{hour}			{ return sym(sym.HOUR);}
{number}			{ return sym(sym.NUMBER);}
{quote}             { return  sym(sym.QUOTE, yytext()); }
{state_name}		{ return sym(sym.SN, new String(yytext())); }
{attr_name}		{ return sym(sym.AN, new String(yytext())); }
{int}			{ return sym(sym.INT, new Integer(yytext())); }
//{op}		{ return sym(sym.OP, new String(yytext())); }


{comment}	 				{;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
