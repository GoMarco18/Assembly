; calc.asm - simple integer calculator (x86-64 NASM)
; Reads: first integer, operator char, second integer
; Supports: +, -, *, /, %
; Uses libc printf & scanf (linked via gcc)

global main
extern printf
extern scanf
extern exit

section .data
    fmt_prompt1    db "Enter first integer: ", 0
    fmt_prompt_op  db "Enter operator (+ - * / %): ", 0
    fmt_prompt2    db "Enter second integer: ", 0
    fmt_scan_ll    db "%lld", 0
    fmt_scan_c     db " %c", 0          ; leading space skips whitespace/newline
    fmt_result     db "Result: %lld", 10, 0
    fmt_divzero    db "Error: division by zero", 10, 0
    fmt_invalid    db "Invalid operator", 10, 0

section .bss
    num1    resq 1
    num2    resq 1
    op      resb 1

section .text
main:
    ; Prompt and read first integer
    mov     rdi, fmt_prompt1
    xor     rax, rax
    call    printf

    mov     rdi, fmt_scan_ll
    lea     rsi, [num1]
    xor     rax, rax
    call    scanf

    ; Prompt and read operator
    mov     rdi, fmt_prompt_op
    xor     rax, rax
    call    printf

    mov     rdi, fmt_scan_c
    lea     rsi, [op]
    xor     rax, rax
    call    scanf

    ; Prompt and read second integer
    mov     rdi, fmt_prompt2
    xor     rax, rax
    call    printf

    mov     rdi, fmt_scan_ll
    lea     rsi, [num2]
    xor     rax, rax
    call    scanf

    ; Load operands into registers
    mov     rax, [num1]        ; dividend / operand1 / accumulator
    mov     rbx, [num2]        ; operand2
    movzx   rcx, byte [op]     ; operator char (zero-extend)

    cmp     rcx, '+' 
    je      .add
    cmp     rcx, '-'
    je      .sub
    cmp     rcx, '*'
    je      .mul
    cmp     rcx, '/'
    je      .div
    cmp     rcx, '%'
    je      .mod

    ; invalid operator
    mov     rdi, fmt_invalid
    xor     rax, rax
    call    printf
    jmp     .exit

.add:
    add     rax, rbx
    jmp     .print

.sub:
    sub     rax, rbx
    jmp     .print

.mul:
    ; two-operand IMUL: rax = rax * rbx (lower 64 bits kept)
    imul    rax, rbx
    jmp     .print

.div:
    ; check division by zero
    cmp     rbx, 0
    je      .divzero
    ; sign-extend rax into rdx:rax for idiv
    cqo
    idiv    rbx        ; quotient -> rax, remainder -> rdx
    jmp     .print

.mod:
    cmp     rbx, 0
    je      .divzero
    cqo
    idiv    rbx
    mov     rax, rdx   ; move remainder to rax for printing
    jmp     .print

.divzero:
    mov     rdi, fmt_divzero
    xor     rax, rax
    call    printf
    jmp     .exit

.print:
    mov     rdi, fmt_result
    ; place the integer arg into rsi (first non-format argument)
    mov     rsi, rax
    xor     rax, rax    ; number of XMM registers used (for variadic call ABI)
    call    printf
    jmp     .exit

.exit:
    mov     rdi, 0
    call    exit
