"""Process ISA XML files into raw asl files.

Working assumptions:
    - for any xml file, the o_path as built by `o_path_of_tree` uniquely identifies the pseudocode in the xml file.
    - no other program concurrently modifies our output files
"""

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
import itertools
import logging
from pathlib import Path
from typing import List, Optional
import textwrap
from xml.etree.ElementTree import Element, parse

# In this whole module, path names used as input (resp. output) are prefixed with `i_` (resp. `o_`).

_logger = logging.getLogger("bundler0")
_last_run_start = datetime.now()

MESSAGE_ON_TOP = """
// Copyright (c) 2010-2022 Arm Limited or its affiliates. All rights reserved.
// This document is Non-Confidential. This document may only be used and
// distributed in accordance with the terms of the agreement entered into by
// Arm and the party that Arm delivered this document to.

// More information can be found in notice.html or 
//    https://developer.arm.com/documentation/ddi0602/latest/Proprietary-Notice

// This document was automatically extracted from the XML files distributed at
//    https://developer.arm.com/downloads/-/exploration-tools
// by a script authored by Hadrien Renaud <hadrien.renaud.22@ucl.ac.uk> and
// available at bundler.py or
//    https://github.com/herd/herdtools7/blob/master/herd/libdir/asl-pseudocode/bundler.py


"""

DEFAULT_INSTR_DIR = Path("other-instrs")

SEPARATOR_LINE = (
    "// ============================================================================="
)


def o_path_of_tree(root: Element, o_dir: Path) -> Path:
    """Constructs and checks the writing file corresponding to this tree."""
    root_type = root.get("type")
    if root_type == "instruction":
        ps_name = root.find("ps_section").find("ps").get("name")
        file_name = Path(ps_name + ".opn")

        if not ps_name.startswith("aarch"):
            _logger.debug(f"Moving file {ps_name} to {DEFAULT_INSTR_DIR}")
            file_name = DEFAULT_INSTR_DIR / file_name

        o_path = o_dir / file_name
        o_path.parent.mkdir(parents=True, exist_ok=True)

    else:
        if root_type != "pseudocode":
            _logger.warning(f"Unknown root type {root_type}")

        o_path = o_dir / (root.get("id").lower() + ".asl")

    if (
        o_path.exists()
        and datetime.fromtimestamp(o_path.stat().st_mtime) < _last_run_start
    ):
        # We consider that if it has been modified after `_last_run_start`, then it is this program that edited it, and
        # so we are overriding our own results. The underlying assumption is that 2 different xml files that have the
        # same o_path have the same pseudocode.
        _logger.warning(f"Overriding {o_path}")

    return o_path


def header_of_tree(root: Element, o_path: Path) -> str:
    """Find a nice title for the written file."""
    root_type = root.get("type")

    titles = [root.get("title")]
    post_header = []

    if root_type == "instruction":
        if o_path.exists():
            with o_path.open(mode="r") as f:
                for line in f.readlines():
                    if line.startswith("// =="):
                        break

                    elif line.startswith("// "):
                        titles.append(line[2:].strip())

            titles = sorted(frozenset(titles))

        post_header.append("// Execute")
        post_header.append("// =======")
        post_header.append("")

    return "\n".join(
        (
            *("// {:^74}".format(i) for i in titles),
            SEPARATOR_LINE,
            "",
            MESSAGE_ON_TOP,
            *post_header,
            "",
        )
    )


def asl_for_instruction_fields(root) -> str:
    """Reads the xml for an instruction and constructs the ASL from it's
    tabular representation of the instruction binary encoding"""

    result = []

    path = ".//classes/iclass/regdiagram"
    nodes = root.findall(path)
    if len(nodes) == 0:
        _logger.warning("Could not find node at %s", path)
        return []
    if len(nodes) >= 2:
        _logger.warning("Too many nodes matching path %s", path)
    node = nodes[0]

    for b in node.findall("./box"):
        name = b.get("name")
        if name is None:
            continue

        name = name.strip()
        if not name.isidentifier():
            _logger.warning("Ignoring uncompatible field name '%s'", name)
            continue

        hibit = b.get("hibit")
        width = b.get("width")

        pos = hibit if width is None else f"{hibit} : ({hibit} - {width} + 1)"
        result.append(f"let {name} = instruction[{pos}];")

    return result


def read_text_in_node(root, path, warn=True) -> [str]:
    """Reads all the text at that path"""
    nodes = root.findall(path)
    if len(nodes) == 0:
        if warn:
            _logger.warning("Could not find node at %s", path)
        return ""
    if len(nodes) >= 2 and warn:
        _logger.warning("Too many nodes matching path %s", path)

    return "".join(nodes[0].itertext())


def one_instruction_to_string(i_path: Path) -> str:
    """Process one instruction, write the decode and write it to output directory"""
    _logger.info("Processing %s", i_path)

    root = parse(i_path).getroot()

    if root.tag != "instructionsection":
        _logger.error("Cannot interpret file %s -- Skipping.", i_path)
        return ""

    root_type = root.get("type")
    if root_type == "pseudocode":
        _logger.info("Skipping shared pseudocode at %s", i_path)
        return ""
    if root_type == "alias":
        _logger.info("Skipping alias at %s.", i_path)
        return ""
    if root_type != "instruction":
        _logger.warning("Unknown xml type at %s -- Skipping", i_path)
        return ""

    operation = read_text_in_node(root, ".//ps_section/ps/pstext[@section='Execute']")
    decode = read_text_in_node(root, ".//ps_section/ps/pstext[@section='Decode']")
    post_decode = read_text_in_node(
        root, ".//ps_section/ps/pstext[@section='Postdecode']", warn=False
    )
    from_bin = asl_for_instruction_fields(root)

    f_name = "instruction_code_" + i_path.stem
    instruction_name = root.get(
        "title", default="Instruction without a name (could not parse it from the xml)"
    )

    function_content = "\n".join(
        (
            "// begining of binary unpacking",
            *from_bin,
            "// end of binary unpacking",
            "",
            "// begining of decode section",
            decode,
            "// end of decode section",
            "",
            "// begining of post decode section",
            post_decode,
            "// end of post decode section",
            "",
            "// begining of execute section",
            operation,
            "// end of execute section",
        )
    )

    text = "\n".join(
        (
            SEPARATOR_LINE,
            f"// {instruction_name}",
            SEPARATOR_LINE,
            "",
            "" f"func {f_name} (instruction: bits(32))",
            "begin",
            textwrap.indent(function_content, "  "),
            "end",
            "",
            "",
        )
    )

    return text


def process_one_file(i_file: Path, o_dir: Path):
    """Process one file and write it to output directory."""
    _logger.info("Processing %s", i_file)

    root = parse(i_file).getroot()

    if root.tag != "instructionsection":
        _logger.error("Cannot interpret file %s -- Skipping.", i_file)
        return

    if root.get("type") == "alias":
        _logger.info("Skipping alias at %s.", i_file)
        return

    o_path = o_path_of_tree(root, o_dir)
    _logger.info("Writing to %s", o_path)

    header = header_of_tree(root, o_path)
    with o_path.open("w") as f:
        f.write(header)

        for ps in root.findall("./ps_section/ps"):
            sect_type = ps.get("secttype")
            if sect_type not in ("Library", "Operation"):
                continue

            _logger.debug("Writing section %s", ps.get("name"))
            f.writelines(ps.find("pstext").itertext())
            f.write("\n\n")

    _logger.debug("Processed %s", i_file)


def get_args() -> (List[Path], Path, Optional[int]):
    """Process arguments."""
    parser = argparse.ArgumentParser(
        description="Process ISA XML files into raw asl files."
    )

    parser.add_argument(
        "-o",
        "--output",
        action="store",
        type=Path,
        default=Path.cwd() / "asl-pseudocode",
        help="The directory where all pseudocode should be written to.",
    )
    parser.add_argument(
        "paths",
        metavar="PATH",
        type=Path,
        nargs="+",
        help="The different paths to parse. If this is a directory, this will (non-recursively) "
        "parse all files inside the directory that have the '.xml' extension.",
    )
    logger_group = parser.add_mutually_exclusive_group()
    logger_group.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Logger level. Can be repeated.",
    )
    logger_group.add_argument(
        "-q", "--quiet", action="store_true", help="Only report critical errors."
    )
    parser.add_argument(
        "--log-file",
        action="store",
        help="Where to write parsing logs. Default to stderr.",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        action="store",
        type=int,
        help="Parallelization on parsing and writing jobs. Default to python's ThreadPoolExecutor"
        "default, which  should be `min(32, cpu_count)`",
    )
    parser.add_argument(
        "-m",
        "--make-functions",
        action="store_true",
        help="Make function and not opns.",
    )

    args = parser.parse_args()

    if args.quiet:
        log_level = logging.CRITICAL
    else:
        v = args.verbose
        if v == 0:
            log_level = logging.ERROR
        elif v == 1:
            log_level = logging.WARNING
        elif v == 2:
            log_level = logging.INFO
        else:
            log_level = logging.DEBUG

    if args.log_file is None:
        logging.basicConfig(level=log_level)
    else:
        logging.basicConfig(filename=args.log_file, filemode="w", level=log_level)

    i_files = []  # type: List[Path]
    for f in args.paths:  # type: Path
        f = f.expanduser()
        if f.is_dir():
            _logger.info("Extending directory %s", f)
            i_files.extend(f.glob("*.xml"))
        elif f.exists():
            i_files.append(f)
        else:
            _logger.warning("Ignoring %s", f)

    o_dir = args.output.absolute()  # type: Path
    if not o_dir.exists():
        _logger.info("Output dir does not exist. Creating it.")
        _logger.debug("mkdir %s", o_dir)
        o_dir.mkdir(exist_ok=True, parents=True)

    elif not o_dir.is_dir():
        _logger.error("Output option is not a directory. Might break later.")

    jobs = args.jobs
    if jobs is None:
        _logger.info("Starting process with default number of parallel workers.")
    else:
        _logger.info("Starting process with %d workers.", jobs)

    make_functions = args.make_functions

    return i_files, o_dir, jobs, make_functions


def main():
    """Main entry point."""
    (i_files, o_dir, jobs, make_functions) = get_args()

    with ThreadPoolExecutor(max_workers=jobs) as executor:

        if make_functions:

            future_strings = (
                executor.submit(one_instruction_to_string, i_file) for i_file in i_files
            )

            o_file = o_dir / "instructions.asl"
            with open(o_file, "w", encoding="utf8") as f:
                f.write(MESSAGE_ON_TOP)

                for future_string in as_completed(future_strings):
                    f.write(future_string.result())

        else:
            executor.map(
                process_one_file, i_files, itertools.repeat(o_dir, len(i_files))
            )


if __name__ == "__main__":
    _last_run_start = datetime.now()
    main()
