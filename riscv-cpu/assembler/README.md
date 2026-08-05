# RV32I Assembler

A custom assembler written in Python for the single-cycle RISC-V RV32I processor developed in this project.

The assembler converts human-readable RISC-V assembly instructions (`.s` files) into 32-bit machine code (`.hex` files) that can be loaded directly into the instruction memory of the custom RISC-V CPU.


## Features

- Parses RISC-V assembly instructions.
- Validates instructions and operands using a centralized ISA definition.
- Encodes supported RV32I instructions into 32-bit RISC-V machine code.
- Generates hexadecimal instruction memory files compatible with the CPU simulation environment.
- Provides error detection for invalid instructions, registers, operand types, and immediate ranges.
- Supports both decimal and hexadecimal immediate values.


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
| JALR | Jump and link register |

### S-Type Instructions

| Instruction | Description |
|-------------|-------------|
| SW | Store word |

### B-Type Instructions

| Instruction | Description |
|-------------|-------------|
| BEQ | Branch if equal |
| BNE | Branch if not equal |

### U-Type Instructions

| Instruction | Description |
|-------------|-------------|
| LUI | Load upper immediate |
| AUIPC | Add upper immediate to PC |

### J-Type Instructions

| Instruction | Description |
|-------------|-------------|
| JAL | Jump and link |


## Usage

From the project root:

```bash
python assembler/assembler.py <input.s> <output.hex>
```

Example:

```bash
python assembler/assembler.py programs/load_store_test.s programs/load_store_test.hex
```