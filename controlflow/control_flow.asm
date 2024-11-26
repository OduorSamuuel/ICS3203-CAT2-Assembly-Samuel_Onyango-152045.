section .data
    prompt db 'Enter a number: ', 0
    result_positive db 'The number is positive.', 0xA, 0
    result_negative db 'The number is negative.', 0xA, 0
    result_zero db 'The number is zero.', 0xA, 0
    input db 0          ; Placeholder for user input

section .bss
    number resb 4       ; Reserve 4 bytes for the integer

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, prompt     ; pointer to message
    mov edx, 16         ; message length
    int 0x80            ; make syscall

    ; Read user input
    mov eax, 3          ; syscall: read
    mov ebx, 0          ; file descriptor: stdin
    mov ecx, input      ; buffer to store input
    mov edx, 4          ; number of bytes to read
    int 0x80            ; make syscall

    ; Convert input (ASCII) to integer
    movzx eax, byte [input] ; Load first byte of input into eax
    sub eax, '0'            ; Convert ASCII to integer
    mov [number], eax       ; Store the integer in 'number'

    ; Classify the number
    mov eax, [number]       ; Load the number
    cmp eax, 0              ; Compare with zero
    je .zero                ; Jump to .zero if eax == 0
    jl .negative            ; Jump to .negative if eax < 0
    jmp .positive           ; Otherwise, it's positive

.positive:
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, result_positive ; pointer to positive message
    mov edx, 25             ; message length
    int 0x80                ; make syscall
    jmp .exit               ; Exit program

.negative:
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, result_negative ; pointer to negative message
    mov edx, 25             ; message length
    int 0x80                ; make syscall
    jmp .exit               ; Exit program

.zero:
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, result_zero     ; pointer to zero message
    mov edx, 20             ; message length
    int 0x80                ; make syscall

.exit:
    mov eax, 1              ; syscall: exit
    xor ebx, ebx            ; exit code: 0
    int 0x80                ; make syscall
