"""
encoder.py

Encodes parsed RISC-V instructions into 32-bit machine code.
"""

from instruction import Instruction
import isa


def encode_instruction(
    instruction: Instruction,
) -> int:
    """
    Encode one parsed instruction into a 32-bit machine instruction.
    """

    definition = isa.get_instruction(
        instruction.mnemonic
    )

    if (
        definition.instruction_format
        == isa.InstructionFormat.R
    ):
        return encode_r_type(
            instruction,
            definition,
        )

    elif (
        definition.instruction_format
        == isa.InstructionFormat.I
    ):
        return encode_i_type(
            instruction,
            definition,
        )

    else:
        raise RuntimeError(
            f"Unsupported instruction format: "
            f"{definition.instruction_format}"
        )


def encode_r_type(
    instruction: Instruction,
    definition: isa.InstructionDefinition,
) -> int:
    """
    Encode one R-Type instruction.
    """

    rd, rs1, rs2 = instruction.operands

    rd = register_to_number(rd)
    rs1 = register_to_number(rs1)
    rs2 = register_to_number(rs2)

    machine_code = (
        (definition.funct7 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (definition.funct3 << 12)
        | (rd << 7)
        | definition.opcode
    )

    return machine_code


def encode_i_type(
    instruction: Instruction,
    definition: isa.InstructionDefinition,
) -> int:
    """
    Encode one I-Type instruction.
    """

    rd, rs1, imm = instruction.operands

    rd = register_to_number(rd)
    rs1 = register_to_number(rs1)
    imm = immediate_to_number(
        imm,
        instruction.line_number,
    )

    machine_code = (
        ((imm & 0xFFF) << 20)
        | (rs1 << 15)
        | (definition.funct3 << 12)
        | (rd << 7)
        | definition.opcode
    )

    return machine_code


def register_to_number(
    register: str,
) -> int:
    """
    Convert a register name into its register number.
    """

    return int(register[1:])


def immediate_to_number(
    immediate: str,
    line_number: int,
) -> int:
    """
    Convert an immediate string into an integer and
    verify that it fits in a signed 12-bit field.
    """

    value = int(immediate)

    if value < -2048 or value > 2047:
        raise ValueError(
            f"Line {line_number}: "
            f"Immediate {value} "
            f"does not fit in a signed 12-bit field."
        )

    return value