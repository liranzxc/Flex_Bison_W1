%{
#include <stdio.h>
#include <string.h>
  /* yylex () and yyerror() need to be declared here */
extern int yylex (void);
extern char * yytext;
void yyerror (const char *s);
%}

%code 
{
  int count_grades=0;
  int sum_points = 0;
   int count_s_one=0;
   int count_s_two=0;
   double sum_students_one = 0 ;
   double sum_students_two = 0 ;


}

/* note: no semicolon after the union */
%union {

   int ival;

   double avg;
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
%type <avg> list_of_grades
%type <avg> student


/* %error-verbose */ 
%%

input: TITLE list_of_students ;
list_of_students: list_of_students student;
list_of_students: /* empty */;
student: BEGIN_STUDENT optional_year list_of_grades END_STUDENT { 

  if($2 == 1 )
  {
    count_s_one = count_s_one +1;
    sum_students_one = sum_students_one + ($3 / sum_points);
  }
  else
  {
    if($2 == 2)
    {
      count_s_two = count_s_two + 1;
      sum_students_two = sum_students_two + ($3 / sum_points);
    }
  }

  count_grades = 0;
  sum_points = 0;
   }; 
optional_year: YEAR EQUELS YEAR_NUMBER SEMICOLON {$$ = $3;}
               | /* empty */ {$$ = 1; }
               ;
list_of_grades: list_of_grades AND grade {
   if($3 == -1){ $$ = $1; } 
   else 
   {
     if(count_grades < 3)
     {
      $$ = $1 + $3;
      count_grades = count_grades +1;
     }
   
   
   }
  };

list_of_grades: grade {

   if($1 != -1)
   {

     if(count_grades < 3)
     {
      $$ = $1;
      count_grades = count_grades +1;
     }
   }

  };


grade: SUBJECT EQUELS NUM {

  if(strcmp($1,"history") == 0)
  {
  $$ = 3*$3;
  if(count_grades < 3)
     {
         sum_points = sum_points + 3;
     }


  }
  else
  {
    $$ = 2*$3;
    if(count_grades < 3)
     {
         sum_points = sum_points + 2;
     }
  }
  
  }
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



      printf("Average of first year students: %.*lf \n",1,(sum_students_one / count_s_one ));
      printf("Average of second year students: %.*lf \n",1,(sum_students_two / count_s_two ));

  return 0;
}

void yyerror (const char *s)
{
  fprintf (stderr, "%s\n", s);
}