#!/usr/bin/env python3
"""
Fetch Jiguang JVerification iOS official docs and store local markdown snapshots.
"""

from __future__ import annotations

import argparse
import html
import re
import sys
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable
from urllib.error import HTTPError, URLError
from urllib.parse import urlparse
from urllib.request import Request, urlopen


USER_AGENT = "Mozilla/5.0 (compatible; jverification-doc-sync/1.0)"


class SimpleTextExtractor(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self._skip_depth = 0
        self._skip_tags = {"script", "style", "noscript", "svg"}
        self._chunks: list[str] = []

    def handle_starttag(self, tag: str, attrs) -> None:  # type: ignore[override]
        if tag in self._skip_tags:
            self._skip_depth += 1

    def handle_endtag(self, tag: str) -> None:  # type: ignore[override]
        if tag in self._skip_tags and self._skip_depth > 0:
            self._skip_depth -= 1
        if not self._skip_depth and tag in {"p", "li", "h1", "h2", "h3", "h4", "tr", "br", "div"}:
            self._chunks.append("\n")

    def handle_data(self, data: str) -> None:  # type: ignore[override]
        if self._skip_depth:
            return
        text = data.strip()
        if text:
            self._chunks.append(text)
            self._chunks.append("\n")

    def get_text(self) -> str:
        raw = "".join(self._chunks)
        lines = [re.sub(r"\s+", " ", line).strip() for line in raw.splitlines()]
        filtered = [line for line in lines if line]
        return "\n".join(filtered)


def now_utc() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%SZ")


def slug_from_url(url: str) -> str:
    parsed = urlparse(url)
    path = parsed.path.strip("/")
    if not path:
        return "root"
    return path.replace("/", "__")


def extract_title(html_text: str, fallback: str) -> str:
    match = re.search(r"<title>(.*?)</title>", html_text, flags=re.IGNORECASE | re.DOTALL)
    if not match:
        return fallback
    title = html.unescape(match.group(1))
    title = re.sub(r"\s+", " ", title).strip()
    return title or fallback


def extract_content_region(html_text: str) -> str:
    match = re.search(
        r'<div class="article-content-box".*?</div>\s*</div>\s*</main>',
        html_text,
        flags=re.IGNORECASE | re.DOTALL,
    )
    if match:
        return match.group(0)
    body_match = re.search(r"<body.*?>(.*)</body>", html_text, flags=re.IGNORECASE | re.DOTALL)
    if body_match:
        return body_match.group(1)
    return html_text


def html_to_text(html_text: str) -> str:
    extractor = SimpleTextExtractor()
    extractor.feed(html_text)
    text = extractor.get_text()
    return text


def read_sources(path: Path) -> list[str]:
    if not path.exists():
        raise FileNotFoundError(f"Sources file not found: {path}")
    lines = path.read_text(encoding="utf-8").splitlines()
    urls = [line.strip() for line in lines if line.strip() and not line.strip().startswith("#")]
    if not urls:
        raise ValueError(f"No valid URLs found in: {path}")
    return urls


def fetch_url(url: str, timeout: int) -> str:
    req = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(req, timeout=timeout) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        payload = resp.read()
    return payload.decode(charset, errors="replace")


def write_snapshot(url: str, html_text: str, output_dir: Path) -> tuple[str, str]:
    slug = slug_from_url(url)
    output_file = output_dir / f"{slug}.md"
    title = extract_title(html_text, fallback=slug)
    content_region = extract_content_region(html_text)
    text_body = html_to_text(content_region)
    fetched_at = now_utc()

    md = [
        f"# {title}",
        "",
        f"- Source: {url}",
        f"- Fetched at (UTC): {fetched_at}",
        "",
        "## Snapshot Text",
        "",
        text_body if text_body else "_No text extracted._",
        "",
    ]
    output_file.write_text("\n".join(md), encoding="utf-8")
    return output_file.name, title


def write_index(output_dir: Path, rows: Iterable[tuple[str, str, str]]) -> None:
    lines = [
        "# JVerification iOS Official Docs Snapshot Index",
        "",
        f"- Generated at (UTC): {now_utc()}",
        "",
        "| File | Title | Source |",
        "| --- | --- | --- |",
    ]
    for file_name, title, source in rows:
        lines.append(f"| `{file_name}` | {title} | {source} |")
    lines.append("")
    (output_dir / "index.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch JVerification iOS official docs snapshots.")
    parser.add_argument(
        "--sources",
        default="references/official_sources.txt",
        help="Path to URL list file.",
    )
    parser.add_argument(
        "--output",
        default="references/official_docs",
        help="Output directory for markdown snapshots.",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=20,
        help="HTTP timeout in seconds.",
    )
    args = parser.parse_args()

    sources_path = Path(args.sources).resolve()
    output_dir = Path(args.output).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    urls = read_sources(sources_path)
    index_rows: list[tuple[str, str, str]] = []
    failures: list[str] = []

    for url in urls:
        try:
            html_text = fetch_url(url, timeout=args.timeout)
            file_name, title = write_snapshot(url, html_text, output_dir)
            index_rows.append((file_name, title, url))
            print(f"[OK] {url} -> {file_name}")
        except (HTTPError, URLError, TimeoutError, UnicodeDecodeError, OSError, ValueError) as exc:
            failures.append(f"{url} ({exc})")
            print(f"[FAIL] {url}: {exc}", file=sys.stderr)

    write_index(output_dir, index_rows)
    print(f"[DONE] Wrote index: {output_dir / 'index.md'}")

    if failures:
        print("[WARN] Failed URLs:", file=sys.stderr)
        for item in failures:
            print(f"  - {item}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
