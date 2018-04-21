import java.io.*;
import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column


token1 = (("%%%%%"("%%")*)|(("**"|"???"){2,3})){odd}*
odd = ("-"(3[13]|2[13579]|1[13579]|[13579]))| ([13579]|[1-9][13579]|[1-2][0-9][13579]|3[0-2][13579]|33[13])
dec =2015"/"12"/"(1[2-9]|2[0-9]|3[0-1])
jan= 2016"/"01"/"([1-4]|[6-9]|1[0-9]|2[0-9]|3[01])
feb= 2016"/"02"/"([1-9]|1[0-9]|2[0-9])
mar= 2016"/"03"/"([1-9]|1[0-3])
token2={dec}("+"|"-")({jan}|{feb}|{mar})
token3= "$"(101|111|1(0|1){3,4}|100(0|1){3}|101000)
comment = "//".*
separator= "##"("##")+
nl = \n|\r|\n\r
quote= \"~\"
number= 0|[1-9][0-9]*

%%

{token1} {return new Symbol(sym.TOKEN1);}
{token2} {return new Symbol(sym.TOKEN2);}
{token3} {return new Symbol(sym.TOKEN3);}
{nl}|" "|\t       { ; }
{comment}         { ; }
{quote}			  {return new Symbol(sym.QUOTE, yytext());}
{separator}		  {return new Symbol(sym.SEP);}
{number} 		  {return new Symbol(sym.NUM, new Integer(yytext())); }
"PRINT_MIN_MAX"	  {return new Symbol(sym.PMM);}
"PART"			  {return new Symbol(sym.PART);}
"m"				  {return new Symbol(sym.M);}	
"m/s"			  {return new Symbol(sym.MS);}
"->"			  {return new Symbol(sym.ARROW);}
"=" 				{ return new Symbol(sym.EQ);}
"|" 				{ return new Symbol(sym.OR);}
"," 				{ return new Symbol(sym.CM);}
";" 				{ return new Symbol(sym.S);}
":" 				{ return new Symbol(sym.COL);}
"(" 				{ return new Symbol(sym.RO);}
")" 				{ return new Symbol(sym.RC);}
"{" 				{ return new Symbol(sym.SO);}
"}" 				{ return new Symbol(sym.SC);}
.					{ System.out.println("Scanner Error: " + yytext()); }



