from dataclasses import dataclass


@dataclass
class Instruction:
    """Represents one parsed assembly instruction."""

    mnemonic: str
    operands: list[str]
    line_number: int