section .data
    ; Simulation messages
    prompt db 'Simulating Water Level Control System', 10, 0
    low_level_msg db 'Water Level: LOW - Motor OFF', 10, 0
    moderate_level_msg db 'Water Level: MODERATE - Motor Running', 10, 0
    high_level_msg db 'Water Level: HIGH - ALARM TRIGGERED! Motor STOPPED', 10, 0
    
    ; Sensor and control port simulation
    SENSOR_PORT equ 0x300   ; Simulated sensor input port
    MOTOR_PORT equ 0x301    ; Simulated motor control port
    ALARM_PORT equ 0x302    ; Simulated alarm control port

section .bss
    sensor_value resb 1     ; Store current sensor reading
    motor_status resb 1     ; Store motor status
    alarm_status resb 1     ; Store alarm status

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

; Simulate reading from sensor port
read_sensor_port:
    ; In a real system, this would read from an actual hardware port
    ; Here we simulate by generating a pseudo-random value
    push ebp
    mov ebp, esp
    
    ; Use a simple method to generate "random" sensor value
    mov eax, [ebp+8]   ; Use passed seed/previous value
    
    ; Simple linear congruential generator
    imul eax, 1103515245
    add eax, 12345
    and eax, 0x7FFFFFFF  ; Ensure positive value
    
    ; Map to water level ranges
    xor edx, edx
    mov ecx, 3
    div ecx
    
    ; EDX now contains 0, 1, or 2 representing water levels
    mov al, dl
    mov [sensor_value], al
    
    mov esp, ebp
    pop ebp
    ret

; Control motor based on sensor input
control_motor:
    push ebp
    mov ebp, esp
    
    ; Get sensor value
    mov al, [sensor_value]
    
    ; Branching logic for motor control
    cmp al, 2      ; High water level
    je .high_level
    
    cmp al, 1      ; Moderate water level
    je .moderate_level
    
    ; Low water level
    mov byte [motor_status], 0  ; Motor OFF
    mov byte [alarm_status], 0  ; Alarm OFF
    push low_level_msg
    push 30
    jmp .output
    
.moderate_level:
    mov byte [motor_status], 1  ; Motor ON
    mov byte [alarm_status], 0  ; Alarm OFF
    push moderate_level_msg
    push 40
    jmp .output
    
.high_level:
    mov byte [motor_status], 0  ; Motor OFF
    mov byte [alarm_status], 1  ; Alarm ON
    push high_level_msg
    push 44
    
.output:
    ; Simulate port write (would be outb instruction in real system)
    mov al, [motor_status]
    out MOTOR_PORT, al
    
    mov al, [alarm_status]
    out ALARM_PORT, al
    
    ; Print status message
    call print_string
    add esp, 8
    
    mov esp, ebp
    pop ebp
    ret

_start:
    ; Print system startup message
    push 40
    push prompt
    call print_string
    add esp, 8
    
    ; Seed for sensor simulation
    mov eax, 0xDEADBEEF
    
    ; Simulate multiple sensor readings
    mov ecx, 5      ; Number of simulation cycles
.simulation_loop:
    ; Read sensor port (simulated)
    push eax
    call read_sensor_port
    add esp, 4
    
    ; Update water level and control motor
    call control_motor
    
    ; Short delay between cycles (system pause)
    mov eax, 162    ; System call for nanosleep
    mov ebx, delay
    mov ecx, 0
    int 0x80
    
    ; Prepare next iteration
    mov eax, [sensor_value]
    loop .simulation_loop
    
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Delay structure for nanosleep
delay:
    times 2 dd 500000000 ; 0.5 seconds