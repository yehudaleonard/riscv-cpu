# Single-Cycle RISC-V CPU

## Overview

Custom 32-bit RISC-V CPU implemented in SystemVerilog.

The current implementation supports a subset of the RISC-V ISA, including R-type and I-type arithmetic instructions. The processor is built using a modular RTL architecture and verified with automated ModelSim regression tests.

The project also includes a custom Python-based assembler that converts RISC-V assembly programs into hexadecimal machine code files that can be loaded directly into the processor's instruction memory.

## Supported Instructions

Currently supported RV32I instruction subset:

### R-Type
- ADD
- SUB
- AND
- OR
- XOR
- SLT

### I-Type
- ADDI

## Architecture

Components:
- Program Counter (PC)
- Instruction Memory (IMEM)
- Decoder
- Control Unit
- Register File
- ALU
- 2-to-1 Multiplexer (MUX)
- Top-level CPU Integration

## Assembler

The assembler supports:

- Assembly parsing and validation
- ISA-based instruction definitions
- RISC-V instruction encoding
- Generation of `.hex` instruction memory files

## Verification

Automated ModelSim regression tests:

- Basic datapath
- ALU operations
- Signed arithmetic
- x0 protection

Each test program is written in RISC-V assembly, assembled into machine code, and executed on the processor simulation.

## Project Structure

- rtl/        RTL implementation
- tb/         SystemVerilog testbenches
- programs/   Assembly programs and generated HEX files
- sim/        ModelSim compilation and regression scripts