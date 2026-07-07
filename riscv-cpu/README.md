# Single-Cycle RISC-V CPU

## Overview

Custom 32-bit RISC-V CPU implemented in SystemVerilog.

## Architecture

Components:
- Program Counter (PC)
- Instruction Memory (IMEM)
- Decoder
- Control Unit
- Register File
- ALU
- MUX

## Verification

Automated ModelSim regression tests:

✓ Basic datapath
✓ ALU operations
✓ Signed arithmetic
✓ x0 protection

## Future Work

- Assembler
- More instructions
- Pipeline architecture