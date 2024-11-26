section .data
    prompt db 'Enter 5 integers (one per line):', 10, 0
    prompt_len equ $ - prompt
    
    output_before db 'Original Array: ', 0
    output_after db 'Reversed Array: ', 0
    
    space db ' ', 0
    newline db 10, 0

section .bss
    array resd 5      ; Reserve space for 5 32-bit integers
    buffer resb 20    ; Buffer for input conversion

section .text
    global _start

; Function to print a string
print_string:
    push ebp
    mov ebp, esp
    
    push eax        ; Preserve eax
    mov eax, 4      ; System call for write
    mov ebx, 1      ; File descriptor (stdout)
    mov ecx, [ebp+8]; String address
    mov edx, [ebp+12]; String length
    int 0x80
    
    pop eax         ; Restore eax
    mov esp, ebp
    pop ebp
    ret

; Function to print an integer
print_int:
    push ebp
    mov ebp, esp
    
    ; Convert integer to string
    mov eax, [ebp+8]
    mov ecx, buffer
    call int_to_string
    
    ; Print the converted string
    push ecx        ; String address
    push eax        ; String length
    call print_string
    add esp, 8
    
    mov esp, ebp
    pop ebp
    ret

; Convert integer to string
int_to_string:
    push ebx
    push ecx
    push edx
    
    mov ebx, 10     ; Division base
    mov ecx, buffer + 19  ; End of buffer
    mov byte [ecx], 0     ; Null terminate
    
.convert_loop:
    dec ecx
    mov edx, 0      ; Clear for division
    div ebx         ; Divide by 10
    add dl, '0'     ; Convert remainder to ASCII
    mov [ecx], dl
    test eax, eax   ; Check if quotient is zero
    jnz .convert_loop
    
    mov eax, buffer + 19
    sub eax, ecx    ; Calculate string length
    
    pop edx
    pop ecx
    pop ebx
    ret

; Function to read integer input
read_int:
    push ebp
    mov ebp, esp
    
    ; Read input into buffer
    mov eax, 3      ; System call for read
    mov ebx, 0      ; File descriptor (stdin)
    mov ecx, buffer
    mov edx, 20     ; Buffer size
    int 0x80
    
    ; Convert string to integer
    mov esi, buffer
    xor eax, eax    ; Clear eax for result
    xor ebx, ebx    ; Clear ebx for digit
    
.parse_loop:
    mov bl, [esi]
    cmp bl, 10      ; Check for newline
    je .done
    cmp bl, 0       ; Check for null terminator
    je .done
    
    ; Multiply current result by 10 and add new digit
    imul eax, 10
    sub bl, '0'     ; Convert ASCII to numeric
    add eax, ebx
    
    inc esi
    jmp .parse_loop
    
.done:
    mov esp, ebp
    pop ebp
    ret

; Array reversal function
reverse_array:
    push ebp
    mov ebp, esp
    
    ; Preserve used registers
    push esi
    push edi
    push ecx
    
    mov esi, array      ; Start of array
    mov edi, array + 16 ; End of array (5th element)
    mov ecx, 2          ; Number of swaps needed
    
.swap_loop:
    ; Swap elements
    mov eax, [esi]
    mov ebx, [edi]
    mov [esi], ebx
    mov [edi], eax
    
    ; Move pointers
    add esi, 4
    sub edi, 4
    
    dec ecx
    jnz .swap_loop
    
    ; Restore registers
    pop ecx
    pop edi
    pop esi
    
    mov esp, ebp
    pop ebp
    ret

_start:
    ; Print input prompt
    push prompt_len
    push prompt
    call print_string
    add esp, 8
    
    ; Read 5 integers
    mov esi, array
    mov ecx, 5
.input_loop:
    push ecx
    call read_int
    mov [esi], eax
    add esi, 4
    pop ecx
    loop .input_loop
    
    ; Print original array
    push output_before
    call print_string
    add esp, 4
    
    mov esi, array
    mov ecx, 5
.print_original_loop:
    push ecx
    push dword [esi]
    call print_int
    
    ; Print space
    push 1
    push space
    call print_string
    add esp, 8
    
    add esi, 4
    pop ecx
    loop .print_original_loop
    
    ; Print newline
    push 1
    push newline
    call print_string
    add esp, 4
    
    ; Reverse the array
    call reverse_array
    
    ; Print reversed array
    push output_after
    call print_string
    add esp, 4
    
    mov esi, array
    mov ecx, 5
.print_reversed_loop:
    push ecx
    push dword [esi]
    call print_int
    
    ; Print space
    push 1
    push space
    call print_string
    add esp, 8
    
    add esi, 4
    pop ecx
    loop .print_reversed_loop
    
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80