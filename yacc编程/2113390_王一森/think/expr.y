%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
typedef union {
    double num;
    char nam;
} YYSTYPE;
int yylex();
extern YYSTYPE yylval; 
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
struct{
    char name;
    double value;
}id[50];
double get(char name);
void insert(char name,double value);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS MUL DIV LEFT RIGHT EQUAL
%token<num> NUMBER
%token<nam> ID
%type <num> expr lines
%right EQUAL
%left ADD MINUS
%left MUL DIV
%right UMINUS       

%%


lines   :       lines expr '\n' { printf("%f\n", $2); }
        |       lines '\n'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$=$1+$3; }
        |       expr MINUS expr   { $$=$1-$3; }
        |       expr MUL expr   { $$=$1*$3;}
        |       expr DIV expr   { $$=$1/$3;}
        |       MINUS expr %prec UMINUS   { $$=-$2; }
        |       LEFT expr RIGHT   { $$=$2; }
        |       ID   { $$=get($1); }
        |       ID EQUAL expr { insert($1,$3); $$=$3; }
        |       NUMBER  { $$=$1; }
        ;

%%

// programs section

int x=0;

double get(char name){
    for(int i=0;i<x;i++){
        if(id[i].name==name){
            return id[i].value;
        }
    }
    return 0;
}   

void insert(char name,double value){
    id[x].name=name;
    id[x].value=value;
    x++;
}

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(isdigit(t)){
            yylval.num = 0;
            while(isdigit(t)){
                yylval.num= yylval.num*10+t-'0';
                t=getchar();
            }
            ungetc(t, stdin); // 把非数字字符放回流中
            return NUMBER;//TODO:解析多位数字返回数字类型 
        }else if (isalpha(t)||(t == '_')) {
            yylval.nam=t;
            return ID; 
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
              case'=':
                   return EQUAL;
              default: 
                   return t;
            }
          }
          return t;
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}