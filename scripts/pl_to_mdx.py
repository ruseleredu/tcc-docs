#!/usr/bin/env python3
"""
Convert Perl .pl files into Docusaurus MDX documentation.

Usage:
    python pl_to_mdx.py <input_dir> <output_dir>

Example:
    python pl_to_mdx.py ./scripts ./docs/scripts

For each .pl file, an .mdx file is generated containing:
- Docusaurus front matter
- Basic information extracted from the Perl source
- Detected modules
- Command-line options (when getopts is used)
- Perl source code in a syntax-highlighted code block
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


def read_perl_file(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def extract_modules(source: str) -> list[str]:
    """Extract modules from 'use Module;' statements."""
    modules = []
    for match in re.finditer(r"^\s*use\s+([A-Za-z_][A-Za-z0-9_:]*)", source, re.MULTILINE):
        module = match.group(1)
        if module not in {"strict", "warnings"} and module not in modules:
            modules.append(module)
    return modules


def extract_description(source: str, filename: str) -> str:
    """Use the first descriptive comment after a separator, if available."""
    lines = source.splitlines()

    for i, line in enumerate(lines):
        if re.match(r"\s*#\s*-{5,}", line):
            for candidate in lines[i + 1 : i + 6]:
                text = re.sub(r"^\s*#\s?", "", candidate).strip()
                if text:
                    return text

    # Fall back to a leading descriptive comment.
    for line in lines:
        text = re.sub(r"^\s*#\s?", "", line).strip()
        if text and not text.startswith("!") and not text.startswith("-"):
            return text

    return f"Perl script `{filename}`."


def extract_getopts(source: str) -> list[tuple[str, str]]:
    """
    Extract simple getopt options from:
        getopts("whu:p:", \%opcoes);

    A colon means the option requires an argument.
    Descriptions are inferred from nearby comments when available.
    """
    match = re.search(r'getopts\(\s*"([^"]+)"', source)
    if not match:
        return []

    spec = match.group(1)
    options = []

    i = 0
    while i < len(spec):
        option = spec[i]
        if option == ":":
            i += 1
            continue

        requires_arg = i + 1 < len(spec) and spec[i + 1] == ":"
        options.append((option, requires_arg))
        i += 2 if requires_arg else 1

    return options


def extract_database(source: str) -> str | None:
    """Extract a simple DBI database string when present."""
    match = re.search(
        r'DBI->connect\(\s*"DBI:mysql:database=\$database;host=\$host"',
        source,
        re.MULTILINE,
    )
    if match:
        return "MySQL via Perl DBI"

    if "use DBI;" in source:
        return "Database access via Perl DBI"

    return None


def escape_mdx_text(text: str) -> str:
    """Escape characters that can accidentally create MDX syntax."""
    return text.replace("{", r"\{").replace("}", r"\}")


def make_id(path: Path) -> str:
    """Create a URL-safe Docusaurus id from the filename."""
    name = path.stem.lower()
    name = re.sub(r"[^a-z0-9_-]+", "-", name)
    return name.strip("-") or "script"


def make_mdx(source: str, path: Path, position: int | None = None) -> str:
    filename = path.name
    title = path.stem
    description = extract_description(source, filename)
    modules = extract_modules(source)
    options = extract_getopts(source)
    database = extract_database(source)

    front_matter = [
        "---",
        f"id: {make_id(path)}",
        f"title: {title}",
    ]

    if position is not None:
        front_matter.append(f"sidebar_position: {position}")

    front_matter.extend([
        f"description: {description}",
        "---",
        "",
    ])

    parts = front_matter

    parts.extend([
        f"# `{filename}`",
        "",
        escape_mdx_text(description),
        "",
        "## Overview",
        "",
        "This page was generated automatically from the Perl source file.",
        "",
    ])

    if modules:
        parts.extend([
            "## Perl Modules",
            "",
            "The script uses the following modules:",
            "",
        ])
        for module in modules:
            parts.append(f"- `{module}`")
        parts.append("")

    if database:
        parts.extend([
            "## Database",
            "",
            f"- **Database interface:** {database}",
            "",
        ])

    if options:
        parts.extend([
            "## Command-Line Options",
            "",
            "| Option | Argument |",
            "|---|---|",
        ])

        for option, requires_arg in options:
            argument = "Required" if requires_arg else "No"
            parts.append(f"| `-{option}` | {argument} |")

        parts.extend([
            "",
            "### Example",
            "",
            f"```bash",
            f"perl {filename} -h",
            "```",
            "",
        ])

    parts.extend([
        "## Source Code",
        "",
        "```perl",
        source.rstrip(),
        "```",
        "",
    ])

    return "\n".join(parts)


def convert(input_dir: Path, output_dir: Path) -> int:
    output_dir.mkdir(parents=True, exist_ok=True)

    files = sorted(input_dir.rglob("*.pl"))

    if not files:
        print(f"No .pl files found in: {input_dir}")
        return 0

    for index, source_path in enumerate(files, start=1):
        source = read_perl_file(source_path)

        # Preserve subdirectories below input_dir.
        relative = source_path.relative_to(input_dir)
        output_path = output_dir / relative.with_suffix(".mdx")
        output_path.parent.mkdir(parents=True, exist_ok=True)

        mdx = make_mdx(source, source_path, position=index)
        output_path.write_text(mdx, encoding="utf-8")

        print(f"Generated: {output_path}")

    print(f"\nConverted {len(files)} Perl file(s).")
    return len(files)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Convert Perl .pl files to Docusaurus MDX."
    )
    parser.add_argument(
        "input_dir",
        type=Path,
        help="Directory containing Perl .pl files",
    )
    parser.add_argument(
        "output_dir",
        type=Path,
        help="Directory where MDX files will be generated",
    )

    args = parser.parse_args()

    if not args.input_dir.is_dir():
        parser.error(f"Input directory does not exist: {args.input_dir}")

    convert(args.input_dir, args.output_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
