.global main
.func main

main:
    MOV R0, #5          @ 将常数5存入寄存器R0，表示n的值
    MOV R1, #1          @ 将常数1存入寄存器R1，表示i的初始值
    MOV R2, #1          @ 将常数1存入寄存器R2，表示result的初始值

loop:
    CMP R1, R0          @ 比较i和n的大小
    BGT print_result      @ 如果i > n，则跳转到print_result标签
    MUL R2, R2, R1      @ 将result乘以i，结果保存在R2中
    ADD R1, R1, #1       @ i加1
    B loop               @ 跳转到loop标签

print_result:
    LDR R3, =format_str     @ 将格式化字符串的地址存入寄存器R3
    LDR R4, =result        @ 将result的地址存入寄存器R4
    STR R2, [SP, #-4]!      @ 将result的值保存到堆栈
    MOV R0, R3          @ 将格式化字符串的地址作为第一个参数
    LDR R1, [SP]          @ 将堆栈中保存的result的值作为第二个参数
    BL printf              @ 调用printf函数
    MOV R0, #0          @ 将常数0存入寄存器R0，表示返回值为0
    BX LR                @ 返回

.section .rodata
.align 2
format_str:
    .asciz "5! = %d\n\0"    @ 格式化字符串
result:
    .word 0
.endfunc               