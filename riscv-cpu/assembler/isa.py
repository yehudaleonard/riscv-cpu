"""
isa.py

Defines the supported RISC-V instruction set.

This module is the single source of truth for instruction
formats, operand types, and encoding information.
"""

from dataclasses import dataclass
from enum import Enum


class InstructionFormat(Enum):
    """Supported RISC-V instruction formats."""

    R = "R"
    I = "I"
    S = "S"
    B = "B"


class OperandType(Enum):
    """Supported assembly operand types."""

    RD = "RD"
    RS1 = "RS1"
    RS2 = "RS2"
    IMM = "IMM"


@dataclass(frozen=True)
class InstructionDefinition:
    """Describes one instruction in the supported ISA."""

    instruction_format: InstructionFormat
    operand_types: list[OperandType]

    opcode: int
    funct3: int
    funct7: int | None


_INSTRUCTIONS = {
    "add": InstructionDefinition(
        instruction_format=InstructionFormat.R,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.RS2,
        ],
        opcode=0b0110011,
        funct3=0b000,
        funct7=0b0000000,
    ),

    "sub": InstructionDefinition(
        instruction_format=InstructionFormat.R,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.RS2,
        ],
        opcode=0b0110011,
        funct3=0b000,
        funct7=0b0100000,
    ),

    "and": InstructionDefinition(
        instruction_format=InstructionFormat.R,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.RS2,
        ],
        opcode=0b0110011,
        funct3=0b111,
        funct7=0b0000000,
    ),

    "or": InstructionDefinition(
        instruction_format=InstructionFormat.R,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.RS2,
        ],
        opcode=0b0110011,
        funct3=0b110,
        funct7=0b0000000,
    ),

    "xor": InstructionDefinition(
        instruction_format=InstructionFormat.R,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.RS2,
        ],
        opcode=0b0110011,
        funct3=0b100,
        funct7=0b0000000,
    ),

    "slt": InstructionDefinition(
        instruction_format=InstructionFormat.R,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.RS2,
        ],
        opcode=0b0110011,
        funct3=0b010,
        funct7=0b0000000,
    ),

    "addi": InstructionDefinition(
        instruction_format=InstructionFormat.I,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.IMM,
        ],
        opcode=0b0010011,
        funct3=0b000,
        funct7=None,
    ),

        "lw": InstructionDefinition(
        instruction_format=InstructionFormat.I,
        operand_types=[
            OperandType.RD,
            OperandType.RS1,
            OperandType.IMM,
        ],
        opcode=0b0000011,
        funct3=0b010,
        funct7=None,
    ),

    "sw": InstructionDefinition(
        instruction_format=InstructionFormat.S,
        operand_types=[
            OperandType.RS2,
            OperandType.RS1,
            OperandType.IMM,
        ],
        opcode=0b0100011,
        funct3=0b010,
        funct7=None,
    ),

    "beq": InstructionDefinition(
        instruction_format=InstructionFormat.B,
        operand_types=[
            OperandType.RS1,
            OperandType.RS2,
            OperandType.IMM,
        ],
        opcode=0b1100011,
        funct3=0b000,
        funct7=None,
    ),

    "bne": InstructionDefinition(
        instruction_format=InstructionFormat.B,
        operand_types=[
            OperandType.RS1,
            OperandType.RS2,
            OperandType.IMM,
        ],
        opcode=0b1100011,
        funct3=0b001,
        funct7=None,
    ),
}


def is_supported_instruction(mnemonic: str) -> bool:
    """
    Return True if the instruction is supported by the assembler.
    """

    return mnemonic in _INSTRUCTIONS


def get_instruction(mnemonic: str) -> InstructionDefinition:
    """
    Return the definition of a supported instruction.
    """

    return _INSTRUCTIONS[mnemonic]
