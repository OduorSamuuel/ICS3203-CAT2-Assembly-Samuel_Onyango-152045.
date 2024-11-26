section .data
    prompt db 'Enter a number to calculate its factorial: ', 0
    result_msg db 'Factorial result: ', 0
    error_msg db 'Error: Input too large or invalid.', 10, 0
    newline db 10, 0

section .bss
    input_buffer resb 20  ; Buffer for input conversion
    result resd 1         ; Store factorial result

section .text
    global _start

; Function to print a string
print_string:
    push ebp
    mov ebp, esp
    
    push eax
    mov eax, 4          ; System call for write
    mov ebx, 1          ; File descriptor (stdout)
    mov ecx, [ebp+8]    ; String address
    mov edx, [ebp+12]   ; String length
    int 0x80
    
    pop eax
    mov esp, ebp
    pop ebp
    ret

; Function to read integer input
read_int:
    push ebp
    mov ebp, esp
    
    ; Read input into buffer
    mov eax, 3          ; System call for read
    mov ebx, 0          ; File descriptor (stdin)
    mov ecx, input_buffer
    mov edx, 20         ; Buffer size
    int 0x80
    
    ; Convert string to integer
    mov esi, input_buffer
    xor eax, eax        ; Clear eax for result
    xor ebx, ebx        ; Clear ebx for digit
    
.parse_loop:
    mov bl, [esi]
    cmp bl, 10          ; Check for newline
    je .done
    cmp bl, 0           ; Check for null terminator
    je .done
    
    ; Multiply current result by 10 and add new digit
    imul eax, 10
    sub bl, '0'         ; Convert ASCII to numeric
    add eax, ebx
    
    inc esi
    jmp .parse_loop
    
.done:
    mov esp, ebp
    pop ebp
    ret

; Integer to string conversion
int_to_string:
    push ebx
    push ecx
    push edx
    
    mov ebx, 10         ; Division base
    mov ecx, input_buffer + 19  ; End of buffer
    mov byte [ecx], 0   ; Null terminate
    
.convert_loop:
    dec ecx
    mov edx, 0          ; Clear for division
    div ebx             ; Divide by 10
    add dl, '0'         ; Convert remainder to ASCII
    mov [ecx], dl
    test eax, eax       ; Check if quotient is zero
    jnz .convert_loop
    
    mov eax, input_buffer + 19
    sub eax, ecx        ; Calculate string length
    mov esi, ecx        ; Return string start
    
    pop edx
    pop ecx
    pop ebx
    ret

; Factorial calculation subroutine
; Input: Number to calculate factorial for in EAX
; Output: Factorial result in EAX, or -1 for error
factorial_subroutine:
    ; Preserve registers
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    
    ; Check for negative input
    test eax, eax
    js .error           ; Jump to error for negative input
    
    ; Special case for 0 and 1
    cmp eax, 1
    jle .base_case      ; Factorial of 0 or 1 is 1
    
    ; Limit input to avoid overflow
    cmp eax, 12         ; 12! is the largest factorial that fits in 32 bits
    ja .error           ; Jump to error if input is greater than 12
    
    ; Initialize accumulator in EBX
    mov ebx, 1          ; EBX will hold the factorial result
    mov ecx, eax        ; ECX is the counter, starts at input number
    
.factorial_loop:
    imul ebx, ecx       ; Multiply accumulator by counter
    dec ecx             ; Decrement counter
    jnz .factorial_loop ; Continue loop until counter reaches 0
    
    ; Store result in EAX
    mov eax, ebx
    jmp .cleanup        ; Skip to cleanup
    
.base_case:
    mov eax, 1          ; 0! and 1! are 1
    jmp .cleanup
    
.error:
    mov eax, -1         ; Indicate an error with -1
    
.cleanup:
    ; Restore registers and return
    pop ecx
    pop ebx
    mov esp, ebp
    pop ebp
    ret

_start:
    ; Print input prompt
    push 39             ; Prompt length
    push prompt
    call print_string
    add esp, 8
    
    ; Read input number
    call read_int
    
    ; Call factorial subroutine
    call factorial_subroutine
    
    ; Check for errors
    cmp eax, -1         ; Check if result indicates error
    je .print_error     ; Jump to error message if so
    
    ; Store result
    mov [result], eax
    
    ; Print result message
    push 19             ; Result message length
    push result_msg
    call print_string
    add esp, 8
    
    ; Convert result to string and print
    mov eax, [result]
    call int_to_string  ; Returns string in ESI, length in EAX
    
    push eax            ; String length
    push esi            ; String address
    call print_string
    add esp, 8
    
    ; Print newline
    push 1
    push newline
    call print_string
    add esp, 4
    jmp .exit_program   ; Skip error printing
    
.print_error:
    ; Print error message
    push 34             ; Error message length
    push error_msg
    call print_string
    add esp, 8

.exit_program:
    ; Exit program
    mov eax, 1
    xor ebx, ebx        ; Exit code 0
    int 0x80
