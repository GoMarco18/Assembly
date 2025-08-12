section .data
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    prompt3 db "Select operation (+, -, *, /): ", 0
    result_msg db "Result: ", 0
    num1 db 0
    num2 db 0
    operation db 0

section .bss
    result resb 4

section .text
    global _start

_start:
    ; Print prompt for first number
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, prompt1    ; message to write
    mov edx, 20         ; message length
    int 0x80

    ; Read first number
    call read_number
    mov [num1], al

    ; Print prompt for second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 21
    int 0x80

    ; Read second number
    call read_number
    mov [num2], al

    ; Print prompt for operation
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, 30
    int 0x80

    ; Read operation
    call read_operation
    mov [operation], al

    ; Perform calculation based on operation
    mov al, [num1]
    mov bl, [num2]

    cmp byte [operation], '+'
    je add
    cmp byte [operation], '-'
    je sub
    cmp byte [operation], '*'
    je mul
    cmp byte [operation], '/'
    je div

    jmp end_program

add:
    add al, bl
    jmp print_result

sub:
    sub al, bl
    jmp print_result

mul:
    mul bl
    jmp print_result

div:
    xor ah, ah        ; Clear high byte for division
    div bl            ; Divide AL by BL
    jmp print_result

print_result:
    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 8
    int 0x80

    ; Convert result to string and print (not implemented in this example)
    ; You would need to implement a function to convert AL to a string

end_program:
    ; Exit program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; exit code 0
    int 0x80

; Function to read a number (single digit)
read_number:
    ; Implementation to read a single digit from user input
    ; This is a placeholder; you would need to implement this
    ret

; Function to read an operation
read_operation:
    ; Implementation to read a single character operation from user input
    ; This is a placeholder; you would need to implement this
    ret
