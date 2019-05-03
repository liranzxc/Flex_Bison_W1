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

{StudentOpen} { return BEGIN_STUDENT; }
{StudentClose} { return END_STUDENT; }
{year}  { return YEAR;}
":"               {return EQUELS; }
{first_year}  {   yylval.year_number = 1; return YEAR_NUMBER;}
{second_year}  {   yylval.year_number = 2; return YEAR_NUMBER;}
";"    		   {return SEMICOLON; }
{subject}  {  strcpy(yylval.subject, yytext);  return SUBJECT;}
{num}   {  yylval.ival = atoi (yytext); return NUM; }
"?"     		   {return QUESTION; }
","              {return AND;}

([a-zA-Z])+     {return TITLE;}

.      		     {showError(); return OTHER;}

%%

void showError(char * s){
    printf("invalid input %s \n",s);
}
