# MIPS-Processor
This project involves designing and implementing a 32-bit single cycle MIPS processor on the Terasic DE10-Lite FPGA board using Verilog HDL.
Team : Manasi and Likhita 

## Overview 

Computer Architecture is defined by its instruction set and architectural state. The MIPS processor  is a 32 bit architecture which consists of the Program Counter (PC) and 32 registers.The processor is built of clocked state elements and combinational logic, so it is a synchronous sequential cicuit. The processor can be viewd as a giant finit state machine. 

The single cycle microarchitecture executes an entire instruction in one cycle. 

Arithmetic\Logic instructions : add, sub, and, or, slt
Memory instructions : lw, sw
Branches : beq, bne

Supported Instructions: (Can add in later) : 

Likhita - ADD,XOR, STL, BEQ
Manasi : SUB, AND, OR, ADDI, LW, SW, J, BNE, 


### DESIGN PROCESSS
There are 2 parts:
1) Datapath : operates on words of data. Memory, registers, ALUs and MUX (all 32bit)
2) Control Path : MUX select, register enable, and memory write signals to control the datapath operations

First we will start developing from the memories and the architectural state (PC and registers).
Then add blocks of combinational logic between the state elemts to compute the new state based on the current state.

**Program Counter** is a 32 bit register, where the output points to the current instruction and the input PC' indicates the address of the next instruction. 

**Instruction Memory** has a single read port that takes in 32 bit instruction address input and reads the 32 bit instruction from that address onto the read data output. (Instr) reads out or fetches the 32 bit instruction.

**Register File** Has 2 read ports and one write port. The read port taks 5 bit address input (A1, A2) since it is 2^5 = 32 registers as source operands. They read the 32 but register value onto read data output RD1 and RD2. The write port takes 5 bit address input A3, a write enable input and a clock.

**Data Memory** has single read/write port. If the write enable (w_en) is 1, it writes data (w_data) into address on the rising edge of the clock. If the write enable is 0 it reads address A onto RD.

 
Tools 
Intel Quartus Prime Lite 18.1 
Model Sim 

##Status 

## References

1) https://www.youtube.com/watch?v=epygWbGCyOY&list=PLy5e471tfAh2wvgPjQxSXad_jP5wn6KDg