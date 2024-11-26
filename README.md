# ICS3203-CAT2-Assembly: Control Flow and Conditional Logic

## Project Overview
This repository contains assembly language implementations for four distinct programming tasks, focusing on low-level system programming techniques.

## Project Structure
```
project-root/
│
├── control-flow/
│   ├── control_flow.asm
│   
│
├── array-reversal/
│   ├── array_reversal.asm
│   
│
├── factorial-calc/
│   ├── factorial_calc.asm
│   
│
└── water-control/
    ├── water_control.asm
    
```

## Folder Navigation and Compilation

### Task 1: Control Flow
```bash
# Navigate to the control flow directory
cd control-flow

# Compile the program
nasm -f elf32 -g -F dwarf control_flow.asm -o control_flow.o
ld -m elf_i386 -o control_flow control_flow.o

# Run the program
./control_flow

# Debug with GDB
gdb ./control_flow
```

### Task 2: Array Reversal
```bash
# Navigate to the array reversal directory
cd array-reversal

# Compile the program
nasm -f elf32 -g -F dwarf array_reversal.asm -o array_reversal.o
ld -m elf_i386 -o array_reversal array_reversal.o

# Run the program
./array_reversal

# Debug with GDB
gdb ./array_reversal
```

### Task 3: Factorial Calculation
```bash
# Navigate to the factorial calculation directory
cd factorial-calc

# Compile the program
nasm -f elf32 -g -F dwarf factorial_calc.asm -o factorial_calc.o
ld -m elf_i386 -o factorial_calc factorial_calc.o

# Run the program
./factorial_calc

# Debug with GDB
gdb ./factorial_calc
```

### Task 4: Water Level Control
```bash
# Navigate to the water control directory
cd water-control

# Compile the program
nasm -f elf32 -g -F dwarf water_control.asm -o water_control.o
ld -m elf_i386 -o water_control water_control.o

# Run the program
./water_control

# Debug with GDB
gdb ./water_control
```

## Prerequisites
- NASM (Netwide Assembler)
- GNU Assembler (gas)
- GDB Debugger
- 32-bit compatibility libraries

## GDB Debugging Commands

### Basic GDB Commands
```
(gdb) break _start    # Set breakpoint at program start
(gdb) run             # Execute the program
(gdb) stepi           # Step through instructions
(gdb) info registers  # View register contents
(gdb) print /x $eax   # Print register in hex
(gdb) continue        # Continue execution
(gdb) quit            # Exit GDB
```

## Task Descriptions

### Task 1: Control Flow and Number Classification
- Number classification (Positive/Negative/Zero)
- Conditional and unconditional jump instructions
- Input validation and conversion

### Task 2: In-Place Array Reversal
- In-place array reversal
- No additional memory allocation
- Handles 5-integer input
- Low-level memory manipulation

### Task 3: Factorial Calculation Subroutine
- Modular factorial calculation
- Register preservation
- Overflow and error handling
- Stack-based computation

### Task 4: Water Level Control Simulation
- Port-based hardware simulation
- Sensor input processing
- Dynamic motor and alarm control
- Pseudo-random state generation

## Debugging Tips

### Common Debugging Scenarios
1. **Register Inspection**
   ```
   (gdb) info registers
   (gdb) print /x $eax   # Hex view
   (gdb) print /t $eax   # Binary view
   ```

2. **Memory Examination**
   ```
   (gdb) x/10x &array    # Examine 10 memory locations
   (gdb) x/s $esi        # View string at ESI
   ```

3. **Breakpoint Management**
   ```
   (gdb) break _start
   (gdb) break factorial_subroutine
   (gdb) info breakpoints
   ```

## Troubleshooting
- Ensure 32-bit compatibility libraries are installed
- Check NASM and GDB versions
- Verify input formats for each program




