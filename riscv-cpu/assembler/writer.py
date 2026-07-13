"""
writer.py

Writes encoded RISC-V machine instructions
into a hexadecimal output file.
"""


def write_hex_file(
    output_path: str,
    machine_code: list[int],
) -> None:
    """
    Write machine code instructions into a .hex file.
    """

    with open(output_path, "w") as output_file:

        for instruction in machine_code:
            output_file.write(
                f"{instruction:08X}\n"
            )