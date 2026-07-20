"""
parser.py

Parses RISC-V assembly instructions and validates
their syntax using the ISA definition.
"""

from instruction import Instruction
import isa


def parse_instruction(line: str, line_number: int) -> Instruction:
    """
    Parse one assembly line and return an Instruction object.
    """

    mnemonic, operands = split_instruction(line)

    validate_mnemonic(mnemonic, line_number)

    definition = isa.get_instruction(mnemonic)

    validate_operands(
        definition,
        operands,
        line_number,
    )

    return Instruction(
        mnemonic=mnemonic,
        operands=operands,
        line_number=line_number,
    )


def split_instruction(line: str) -> tuple[str, list[str]]:
    """
    Split an assembly line into mnemonic and operands.
    """

    parts = line.split(maxsplit=1)

    mnemonic = parts[0]

    # If the instruction has no operand section,
    # represent it as an empty operand list.
    if len(parts) == 1:
        operands = []
    else:
        operands = [
            operand.strip()
            for operand in parts[1].split(",")
        ]

    if mnemonic in ("lw", "sw"):
        operands = parse_memory_operands(operands)

    return mnemonic, operands

def parse_memory_operands(
    operands: list[str],
) -> list[str]:
    """
    Convert memory operand syntax.

    Example:

        ["x5", "8(x1)"]

    becomes

        ["x5", "x1", "8"]
    """

    if len(operands) != 2:
        return operands

    register = operands[0]
    memory_operand = operands[1]

    left_paren = memory_operand.find("(")
    right_paren = memory_operand.find(")")

    if (
        left_paren == -1
        or right_paren == -1
        or right_paren < left_paren
    ):
        return operands

    immediate = memory_operand[:left_paren].strip()
    base_register = memory_operand[
        left_paren + 1:right_paren
    ].strip()

    return [
        register,
        base_register,
        immediate,
    ]


def validate_mnemonic(
    mnemonic: str,
    line_number: int,
) -> None:
    """
    Check that the instruction exists in the ISA.
    """

    if not isa.is_supported_instruction(mnemonic):
        raise ValueError(
            f"Line {line_number}: "
            f"Unknown instruction '{mnemonic}'."
        )


def validate_operands(
    definition: isa.InstructionDefinition,
    operands: list[str],
    line_number: int,
) -> None:
    """
    Validate operand count and operand types.
    """

    expected = len(definition.operand_types)

    if len(operands) != expected:
        raise ValueError(
            f"Line {line_number}: "
            f"Expected {expected} operands, "
            f"got {len(operands)}."
        )

    for expected_type, operand in zip(
        definition.operand_types,
        operands,
    ):

        if expected_type in (
            isa.OperandType.RD,
            isa.OperandType.RS1,
            isa.OperandType.RS2,
        ):
            validate_register(
                operand,
                line_number,
            )

        elif expected_type == isa.OperandType.IMM:
            validate_immediate(
                operand,
                line_number,
            )

        else:
            raise RuntimeError(
                f"Unsupported operand type: {expected_type}"
            )


def validate_register(
    register: str,
    line_number: int,
) -> None:
    """
    Validate a RISC-V register name.
    """

    if not register.startswith("x"):
        raise ValueError(
            f"Line {line_number}: "
            f"Expected register, got '{register}'."
        )

    register_number = register[1:]

    if not register_number.isdigit():
        raise ValueError(
            f"Line {line_number}: "
            f"Invalid register '{register}'."
        )

    register_number = int(register_number)

    if register_number < 0 or register_number > 31:
        raise ValueError(
            f"Line {line_number}: "
            f"Invalid register '{register}'."
        )


def validate_immediate(
    immediate: str,
    line_number: int,
) -> None:
    """
    Validate an immediate value.
    """

    if not immediate.lstrip("-").isdigit():
        raise ValueError(
            f"Line {line_number}: "
            f"Expected immediate, got '{immediate}'."
        )