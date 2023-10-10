%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
bison --yacc -dv expr.y
gcc y.tab.c -o compute_expr
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char num[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char*s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS MUL DIV LEFT RIGHT
%token NUMBER
%left ADD MINUS
%left MUL DIV
%right UMINUS
%%


lines   :       lines expr '\n' { printf("%s\n", $2); }
        |       lines '\n'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"+ "); }
        |       expr MINUS expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"- "); }
        |       expr MUL expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"* "); }
        |       expr DIV expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"/ "); }
        |       LEFT expr RIGHT   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$,$2); }
        |       NUMBER  { $$ = (char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," "); }
        ;

%%

// programs section

int yylex()
{
      int t;
      while(1){
          t=getchar();     
          if(t==' '||t=='\t'||t=='\n'){
            //do nothing
          }else if(isdigit(t)){
                  int x = 0;
                  while(isdigit(t)){
                  num[x]=t;
                  t=getchar();
                  x++;
                }
           num[x]='\0';
           yylval=num;
           ungetc(t,stdin);
           return NUMBER;//TODO:解析多位数字返回数字类型 
         }else {
            switch(t)
           {
              case '+':
                   return ADD;
              case '-':
                   return MINUS;
              case '*':
                   return MUL;
              case '/':
                   return DIV;
              case'(':
                   return LEFT;
              case')':
                   return RIGHT;
              default: 
                   return t;
            }
          }
          return t;
    }
}

int main(void)
{
   yyin = stdin;
  do{
      yyparse();
    }while(!feof(yyin));
  return 0;
}
void yyerror(const char* s)
{
   fprintf(stderr,"Parse error:%s\n",s);
   exit(1);
}
