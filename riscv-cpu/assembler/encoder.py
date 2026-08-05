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

    elif (
        definition.instruction_format
        == isa.InstructionFormat.S
    ):
        return encode_s_type(
            instruction,
            definition,
        )

    elif (
        definition.instruction_format
        == isa.InstructionFormat.B
    ):
        return encode_b_type(
            instruction,
            definition,
        )

    elif (
        definition.instruction_format
        == isa.InstructionFormat.U
    ):
        return encode_u_type(
            instruction,
            definition,
        )

    elif (
        definition.instruction_format
        == isa.InstructionFormat.J
    ):
        return encode_j_type(
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
    imm = immediate_to_number(imm)

    if imm < -2048 or imm > 2047:
        raise ValueError(
            f"Line {instruction.line_number}: "
            f"Immediate {imm} "
            f"does not fit in a signed 12-bit field."
        )

    machine_code = (
        ((imm & 0xFFF) << 20)
        | (rs1 << 15)
        | (definition.funct3 << 12)
        | (rd << 7)
        | definition.opcode
    )

    return machine_code


def encode_s_type(
    instruction: Instruction,
    definition: isa.InstructionDefinition,
) -> int:
    """
    Encode one S-Type instruction.
    """

    rs2, rs1, imm = instruction.operands

    rs2 = register_to_number(rs2)
    rs1 = register_to_number(rs1)
    imm = immediate_to_number(imm)

    if imm < -2048 or imm > 2047:
        raise ValueError(
            f"Line {instruction.line_number}: "
            f"Immediate {imm} "
            f"does not fit in a signed 12-bit field."
        )

    imm_upper = (imm >> 5) & 0x7F
    imm_lower = imm & 0x1F

    machine_code = (
        (imm_upper << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (definition.funct3 << 12)
        | (imm_lower << 7)
        | definition.opcode
    )

    return machine_code


def encode_b_type(
    instruction: Instruction,
    definition: isa.InstructionDefinition,
) -> int:
    """
    Encode one B-Type instruction.
    """

    rs1, rs2, imm = instruction.operands

    rs1 = register_to_number(rs1)
    rs2 = register_to_number(rs2)
    imm = immediate_to_number(imm)

    if imm < -4096 or imm > 4094:
        raise ValueError(
            f"Line {instruction.line_number}: "
            f"Branch offset {imm} "
            f"does not fit in a signed 13-bit field."
        )

    if imm % 4 != 0:
        raise ValueError(
            f"Line {instruction.line_number}: "
            "Branch offset must be aligned to 4 bytes."
        )

    imm &= 0x1FFF

    imm_12   = (imm >> 12) & 0x1
    imm_10_5 = (imm >> 5) & 0x3F
    imm_4_1  = (imm >> 1) & 0xF
    imm_11   = (imm >> 11) & 0x1

    machine_code = (
        (imm_12   << 31)
        | (imm_10_5 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (definition.funct3 << 12)
        | (imm_4_1 << 8)
        | (imm_11 << 7)
        | definition.opcode
    )

    return machine_code


def encode_u_type(
    instruction: Instruction,
    definition: isa.InstructionDefinition,
) -> int:
    """
    Encode one U-Type instruction.
    """

    rd, imm = instruction.operands

    rd = register_to_number(rd)
    imm = immediate_to_number(imm)

    if imm < 0 or imm > 0xFFFFF:
        raise ValueError(
            f"Line {instruction.line_number}: "
            f"Immediate {imm} "
            f"does not fit in a 20-bit field."
        )

    machine_code = (
        (imm << 12)
        | (rd << 7)
        | definition.opcode
    )

    return machine_code


def encode_j_type(
    instruction: Instruction,
    definition: isa.InstructionDefinition,
) -> int:
    """
    Encode one J-Type instruction.
    """

    rd, imm = instruction.operands

    rd = register_to_number(rd)

    imm = immediate_to_number(imm)

    if imm < -(2 ** 20) or imm > ((2 ** 20) - 2):
        raise ValueError(
            f"Line {instruction.line_number}: "
            f"Jump offset {imm} "
            f"does not fit in a signed 21-bit field."
        )

    if imm % 4 != 0:
        raise ValueError(
            f"Line {instruction.line_number}: "
            "Jump offset must be aligned to 4 bytes."
        )

    imm &= 0x1FFFFF

    imm_20 = (imm >> 20) & 0x1
    imm_10_1 = (imm >> 1) & 0x3FF
    imm_11 = (imm >> 11) & 0x1
    imm_19_12 = (imm >> 12) & 0xFF

    machine_code = (
        (imm_20 << 31)
        | (imm_10_1 << 21)
        | (imm_11 << 20)
        | (imm_19_12 << 12)
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
) -> int:
    """
    Convert an immediate string into an integer.
    """

    return int(immediate, 0)