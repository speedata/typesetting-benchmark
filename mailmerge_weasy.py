#!/usr/bin/env python3
"""Mail merge with WeasyPrint: reads fakenames.xml, renders HTML template, produces PDF."""

import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML

BASE_DIR = Path(__file__).parent


def load_records(xml_path: Path) -> list[dict]:
    tree = ET.parse(xml_path)
    return [elem.attrib for elem in tree.getroot().findall("record")]


def main():
    xml_name = sys.argv[1] if len(sys.argv) > 1 else "fakenames.xml"
    records = load_records(BASE_DIR / xml_name)

    env = Environment(loader=FileSystemLoader(BASE_DIR), autoescape=True)
    template = env.get_template("mailmerge_template.html")
    html_str = template.render(records=records)

    # Debug: save intermediate HTML (optional)
    (BASE_DIR / "mailmerge_weasy_debug.html").write_text(html_str, encoding="utf-8")

    HTML(string=html_str, base_url=str(BASE_DIR)).write_pdf(
        BASE_DIR / "mailmerge_weasy.pdf"
    )
    print(f"PDF generated: mailmerge_weasy.pdf ({len(records)} letters)")


if __name__ == "__main__":
    main()
