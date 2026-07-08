# Single-Cycle RISC-V CPU

## Overview

Custom 32-bit RISC-V CPU implemented in SystemVerilog.

The current implementation supports a subset of the RISC-V ISA, including R-type and I-type arithmetic instructions. The processor is built using a modular RTL architecture and verified with automated ModelSim regression tests.

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

## Verification

Automated ModelSim regression tests:

- Basic datapath
- ALU operations
- Signed arithmetic
- x0 protection

## Project Structure

- rtl/        RTL implementation
- tb/         SystemVerilog testbenches
- programs/   HEX programs used for CPU verification
- sim/        ModelSim compilation and regression scripts