%{
#include <stdio.h>

  /* yylex () and yyerror() need to be declared here */
extern int yylex (void);
extern char * yytext;
void yyerror (const char *s);
%}

/* note: no semicolon after the union */
%union {

   int avg_studnet;
   int avg_year_one;
   int avg_year_two;

   int count_s_one;
   int count_s_two;
   int ival;

   int year_number;
   char subject[100];


}

%token NUM TITLE AND SEMICOLON QUESTION EQUELS BEGIN_STUDENT END_STUDENT YEAR SUBJECT YEAR_NUMBER OTHER

%type <ival> NUM
%type <ival> YEAR_NUMBER
%type <subject> SUBJECT
%type <subject> TITLE

%type <ival> optional_year
%type <ival> grade
%type <ival> list_of_grades
%type <ival> student


/* %error-verbose */ 
%%

input: TITLE list_of_students;
list_of_students: list_of_students student;
list_of_students: /* empty */;
student: BEGIN_STUDENT optional_year list_of_grades END_STUDENT { printf("Student Year %d  , sum of grades %d \n",$2,$3); }; 
optional_year: YEAR EQUELS YEAR_NUMBER SEMICOLON {$$ = $3;}
               | /* empty */ {$$ = 1; }
               ;
list_of_grades: list_of_grades AND grade {
   if($3 == -1)
   { $$ = $1; } 
   else 
   {
     
      $$ = $1 + $3;  
     
  }
   
   
   
   };
list_of_grades: grade {$$ = $1;};
grade: SUBJECT EQUELS NUM {$$ = $3;}
      | 
      SUBJECT EQUELS QUESTION {$$ = -1;}
      ;

%%
int main (int argc, char **argv)
{
  extern FILE *yyin;
  if (argc != 2) {
     fprintf (stderr, "Usage: %s <input-file-name>\n", argv[0]);
	 return 1;
  }
  yyin = fopen (argv [1], "r");
  if (yyin == NULL) {
       fprintf (stderr, "failed to open %s\n", argv[1]);
	   return 2;
  }
  
  yyparse ();
  
  fclose (yyin);
  return 0;
}

void yyerror (const char *s)
{
  fprintf (stderr, "%s\n", s);
}