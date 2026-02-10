#!/usr/bin/env python3
"""Mail merge with LuaLaTeX: reads fakenames.xml, renders LaTeX template, produces PDF."""

import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

BASE_DIR = Path(__file__).parent

LATEX_SPECIAL = str.maketrans({
    "&": r"\&",
    "%": r"\%",
    "$": r"\$",
    "#": r"\#",
    "_": r"\_",
    "{": r"\{",
    "}": r"\}",
    "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}",
    "\\": r"\textbackslash{}",
})


def escape_latex(s: str) -> str:
    return s.translate(LATEX_SPECIAL)


def load_records(xml_path: Path) -> list[dict]:
    tree = ET.parse(xml_path)
    return [
        {k: escape_latex(v) for k, v in elem.attrib.items()}
        for elem in tree.getroot().findall("record")
    ]


def main():
    xml_name = sys.argv[1] if len(sys.argv) > 1 else "fakenames.xml"
    records = load_records(BASE_DIR / xml_name)

    env = Environment(
        loader=FileSystemLoader(BASE_DIR),
        block_start_string="<%",
        block_end_string="%>",
        variable_start_string="<<",
        variable_end_string=">>",
        comment_start_string="<#",
        comment_end_string="#>",
    )
    template = env.get_template("mailmerge_template_lualatex.tex")
    tex_str = template.render(records=records)

    tex_path = BASE_DIR / "mailmerge_lualatex.tex"
    tex_path.write_text(tex_str, encoding="utf-8")

    subprocess.run(
        [
            "lualatex",
            "-interaction=nonstopmode",
            f"--output-directory={BASE_DIR}",
            str(tex_path),
        ],
        capture_output=True,
        check=True,
    )
    print(f"PDF generated: mailmerge_lualatex.pdf ({len(records)} letters)")


if __name__ == "__main__":
    main()
