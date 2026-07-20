# Single-Cycle RISC-V CPU

## Overview

Custom 32-bit single-cycle RISC-V processor implementing a subset of the RV32I instruction set.

The processor currently supports arithmetic, logical, comparison, immediate, and load/store instructions. It is built using a modular RTL architecture and verified with automated ModelSim regression tests.

The project also includes a custom Python-based assembler that converts RISC-V assembly programs into hexadecimal machine code files that can be loaded directly into the processor's instruction memory.

## Supported Instructions

Currently supported RV32I instruction subset:

### R-Type Instructions

| Instruction | Description |
|-------------|-------------|
| ADD | Integer addition |
| SUB | Integer subtraction |
| AND | Bitwise AND |
| OR  | Bitwise OR |
| XOR | Bitwise XOR |
| SLT | Set less than |

### I-Type Instructions

| Instruction | Description |
|-------------|-------------|
| ADDI | Add immediate |
| LW | Load word |

### S-Type Instructions

| Instruction | Description |
|-------------|-------------|
| SW | Store word |

## Architecture

Main RTL components:

- Program Counter (PC)
- Instruction Memory (IMEM)
- Data Memory (DMEM)
- Instruction Decoder
- Control Unit
- Register File
- Arithmetic Logic Unit (ALU)
- 2-to-1 Multiplexers (MUX)
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
- Signed operations
- x0 protection
- Store (SW)
- Load (LW)
- Load/store integration

Each test program is written in RISC-V assembly, assembled into machine code, and executed on the processor simulation.

## Simulation

Run the complete CPU regression:

```bash
vsim -do sim/regression.do
```

## Project Structure

| Directory | Description |
|----------|-------------|
| `rtl/` | SystemVerilog RTL modules |
| `tb/` | SystemVerilog testbenches |
| `assembler/` | Custom Python RV32I assembler |
| `programs/` | Assembly programs and generated `.hex` files |
| `sim/` | ModelSim compilation and regression scripts |

## Tool Flow

Assembly (.s)
        │
        ▼
Custom Python Assembler
        │
        ▼
Machine Code (.hex)
        │
        ▼
Instruction Memory
        │
        ▼
Single-Cycle RV32I CPU
        │
        ▼
ModelSim Simulation & Regression Tests