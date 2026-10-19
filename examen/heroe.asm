section .data

    pregunta     db "Nombre: "
    pregunta_len  equ $ - pregunta

section .bss

    nombre resb 16

section .text

    global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, pregunta
    mov rdx, pregunta_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, nombre
    mov rdx, 16
    syscall

    dec rax
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, nombre
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
