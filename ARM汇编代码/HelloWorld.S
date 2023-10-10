.data
   str: .asciz "Hello World\n"  @ 定义一个以空结尾的字符串
.text
.globl main
 main: stmfd sp!,{lr}   @ 把返回地址推到堆栈上
   ldr r0, =str        @ 加载指向格式化字符串的指针
   bl printf          @ printf("Hello World\n");
   mov r0, #0       @ move return code into r0
   ldmfd sp!,{lr}     @ 从堆栈弹出返回地址
 mov pc, lr         @ return to Linux
 .end              @ 结束汇编程序