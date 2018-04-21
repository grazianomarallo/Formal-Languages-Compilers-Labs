import java.io.*;
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


token1 = {date}("-"| "#"){date}("-"| "#"){date}(("-"| "#"){date}("-"| "#"){date})*


day30=0[1-9]|[1-2][0-9]|30
day31=0[1-9]|[1-2][0-9]|3[0-1]
month_day=(09)"/"{day30}|(08)"/"{day31}|07"/"(0[2-9]|[1-2][0-9]|3[0-1])|10"/"(0[1-9]|1[0-9]|2[0-1])
year=2017
date={year}"/"{month_day}

token2 = ("$"{word})|("$"{binary})


word= ({no_vowels}*{vowels}{no_vowels}*{vowels}{no_vowels}*)|({no_vowels}*{vowels}{no_vowels}*{vowels}{no_vowels}*{vowels}{no_vowels}*{vowels}{no_vowels}{vowels}{no_vowels}*)
no_vowels = [qwrtypsdfghjklzxcvbnm]
vowels= [aeiou]
binary= (10|11|100|101|111|1(0|1){3,4}|100(0|1){3}|101001)
token3= (("@"|"%"|"&"){4}(("@"|"%"|"&")("@"|"%"|"&"))*)({odd})? 
neg=[13579]|[1-3][13579]|4[13]
pos=[13579]|[1-9][13579]|[1-9][0-9][13579]|1(00([13579])|0([1-9][13579])|1[0-9][13579]|2(0[13579]|[1-2][13579]|3[1]))
odd="-"{neg}|{pos}
name = [a-zA-Z_]+[0-9]*
comment = "//".*
separator= "****"|"****"("*")*
nl = \n|\r|\n\r
quote= \"~\"
int =  [0-9] |[1-9][0-9]*

%%

{token1} {return sym(sym.TOKEN1);}
{token2} {return sym(sym.TOKEN2);}
{token3} {return sym(sym.TOKEN3);}
{nl}|" "|\t       { ; }
{comment}         { ; }
{quote}			  {return sym(sym.QUOTE, yytext());}
{separator}		  {return sym(sym.SEP);}
"START"	  {return sym(sym.START);}
"STATE"			  {return sym(sym.STATE);}
"IF"				  {return sym(sym.IF);}	
"DONE"			  {return sym(sym.DONE);}
"CASE"			  {return sym(sym.CASE);}
"DO"			  {return sym(sym.DO);}
"PRINT"			  {return sym(sym.PRINT);}
"NEW STATE"			  {return sym(sym.NEWS);}
"FI"			  {return sym(sym.FI);}
"." 				{ return sym(sym.DOT);}
"=" 				{ return sym(sym.EQ);}
"," 				{ return sym(sym.CM);}
";" 				{ return sym(sym.S);}
":" 				{ return sym(sym.COL);}
"(" 				{ return sym(sym.RO);}
")" 				{ return sym(sym.RC);}
"{" 				{ return sym(sym.SO);}
"}" 				{ return sym(sym.SC);}
"&&"			{ return sym(sym.AND); }
"||"				{ return sym(sym.OR); }
"!="                { return sym(sym.NOTEQ); }
"=="                { return sym(sym.EQEQ); }
{name}			{ return sym(sym.NAME, yytext()); }
{int}			{ return sym(sym.INT, new Integer(yytext())); }
.					{ System.out.println("Scanner Error: " + yytext()); }



