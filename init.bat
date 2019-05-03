bison student.y
flex student.l
gcc -o student.exe lex.yy.c student.tab.c
student.exe student.txt