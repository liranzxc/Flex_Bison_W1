%{

#include <stdio.h>
#include <string.h>
#include "student.tab.h"
extern int atoi (const char *);
void showError();
%}


%option noyywrap

StudentOpen "<student>"
StudentClose "</student>"
year "year"
subject        "algebra"|"programming languages"|"Java"|"history"|"physics"
first_year     "freshman"|"first"
second_year    "second"|"sophomore"
num         ([0-9])+ 
WhiteSpaces             [\r\t\f\v ]+

%%
[\n\t ]+   {} /* skip white space */
{WhiteSpaces} {}

{StudentOpen} {printf("found S Open %s \n" ,yytext); return BEGIN_STUDENT; }
{StudentClose} {printf("found S Close %s \n" ,yytext); return END_STUDENT; }
{year}  {printf("found year \n"); return YEAR;}
":"               {return EQUELS; }
{first_year}  { printf("found first year %s \n " ,yytext);  yylval.year_number = 1; return YEAR_NUMBER;}
{second_year}  { printf("found second year %s \n" ,yytext);  yylval.year_number = 2; return YEAR_NUMBER;}
";"    		   {return SEMICOLON; }
{subject}  { printf("found subject %s \n" ,yytext);   return SUBJECT;}
{num}   {printf("found a grade %s \n " ,yytext);  yylval.ival = atoi (yytext); return NUM; }
"?"     		   {return QUESTION; }
","              {return AND;}

([a-zA-Z])+     {printf("found title %s \n" ,yytext);return TITLE;}

.      		     {showError(); return OTHER;}

%%

void showError(char * s){
    printf("invalid input %s \n",s);
}
