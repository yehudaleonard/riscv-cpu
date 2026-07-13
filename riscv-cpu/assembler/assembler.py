"""
assembler.py

Main entry point for the RISC-V assembler.

Current functionality:
- Accept input and output file paths from the command line.
- Read the input assembly file.
- Print each line with its line number.

Future functionality:
- Parse assembly instructions.
- Encode machine instructions.
- Write the output .hex file.
"""

from pathlib import Path
import sys
import parser
import encoder
import writer


def main() -> None:
    """Main entry point for the assembler."""

    if len(sys.argv) != 3:
        print("Usage:")
        print("    python assembler.py <input.s> <output.hex>")
        sys.exit(1)

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    print(f"Reading: {input_path}")
    print(f"Output : {output_path}")
    print()

    machine_code = []

    with input_path.open("r") as source_file:
        for line_number, line in enumerate(source_file, start=1):
            line = line.split("#")[0]
            line = line.strip()

            if not line:
                continue

            instruction = parser.parse_instruction(
                line,
                line_number,
            )

            encoded_instruction = encoder.encode_instruction(
                instruction,
            )

            machine_code.append(
                encoded_instruction
            )

    writer.write_hex_file(
        output_path,
        machine_code,
    )
    
    print()
    print(f"Wrote {len(machine_code)} instructions to {output_path}")
    print("Done.")


if __name__ == "__main__":
    main()