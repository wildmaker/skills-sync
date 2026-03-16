#!/usr/bin/env python3
"""
Search local JVerification iOS doc snapshots by keyword.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


def search_files(query: str, docs_dir: Path, ignore_case: bool, limit: int) -> int:
    pattern = re.compile(re.escape(query), re.IGNORECASE if ignore_case else 0)
    printed = 0

    files = sorted(p for p in docs_dir.glob("*.md") if p.name != "index.md")
    for file_path in files:
        lines = file_path.read_text(encoding="utf-8", errors="replace").splitlines()
        for idx, line in enumerate(lines, start=1):
            if pattern.search(line):
                print(f"{file_path.name}:{idx}: {line}")
                printed += 1
                if printed >= limit:
                    return printed
    return printed


def main() -> int:
    parser = argparse.ArgumentParser(description="Query local JVerification iOS doc snapshots.")
    parser.add_argument("query", help="Keyword to search.")
    parser.add_argument(
        "--docs",
        default="references/official_docs",
        help="Path to local docs snapshot directory.",
    )
    parser.add_argument(
        "--case-sensitive",
        action="store_true",
        help="Use case-sensitive matching.",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=60,
        help="Maximum number of matching lines to print.",
    )
    args = parser.parse_args()

    docs_dir = Path(args.docs).resolve()
    if not docs_dir.exists():
        print(f"Docs directory not found: {docs_dir}")
        return 1

    count = search_files(
        query=args.query,
        docs_dir=docs_dir,
        ignore_case=not args.case_sensitive,
        limit=args.limit,
    )

    if count == 0:
        print("No matches found.")
        return 2

    print(f"\nMatched lines: {count}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
