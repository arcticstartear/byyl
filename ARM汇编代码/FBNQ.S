.global main
.func main

main:
    MOV R0, #10         @ 将常数10存入寄存器R0，表示n的值
    MOV R1, #0          @ 将常数0存入寄存器R1，表示a的初始值
    MOV R2, #1          @ 将常数1存入寄存器R2，表示b的初始值

loop:
    CMP R0, #2          @ 比较n和2的大小
    BLE exit              @ 如果n <= 2，则跳转到exit标签
    ADD R3, R1, R2       @ 将a与b相加，结果保存到寄存器R3中
    BL printf             @ 调用printf函数打印结果
    MOV R1, R2          @ 将b的值赋给a
    MOV R2, R3          @ 将计算结果赋给b
    SUB R0, R0, #1       @ n减1
    B loop               @ 跳转到loop标签

exit:
    MOV R0, #0          @ 将常数0存入寄存器R0，表示返回值为0
    BX LR               @ 返回

.section .rodata
.align 2
format_str:
    .asciz "%d\n\0"     @ 格式化字符串

.endfunc