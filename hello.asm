section .data
    msg db 'Hello, World!', 0xA   ; Message to print
    len equ $ - msg               ; Length of the message

section .text
    global _start

_start:
    ; Write syscall
    mov rax, 1        ; syscall: write
    mov rdi, 1        ; file descriptor: stdout
    mov rsi, msg      ; pointer to message
    mov rdx, len      ; length of message
    syscall

    ; Exit syscall
    mov rax, 60       ; syscall: exit
    xor rdi, rdi      ; exit code: 0
    syscall
