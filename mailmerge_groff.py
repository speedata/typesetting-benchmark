#!/usr/bin/env python3
"""Mail merge with groff: reads fakenames.xml, generates groff source, produces PDF."""

import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

BASE_DIR = Path(__file__).parent

BODY_TEXT = (
    "but I must explain to you how all this mistaken idea of "
    "denouncing pleasure and praising pain was born and I will give "
    "you a complete account of the system, and expound the actual "
    "teachings of the great explorer of the truth, the master-builder "
    "of human happiness. No one rejects, dislikes, or avoids pleasure "
    "itself, because it is pleasure, but because those who do not know "
    "how to pursue pleasure rationally encounter consequences that are "
    "extremely painful. Nor again is there anyone who loves or pursues "
    "or desires to obtain pain of itself, because it is pain, but "
    "because occasionally circumstances occur in which toil and pain "
    "can procure him some great pleasure. To take a trivial example, "
    "which of us ever undertakes laborious physical exercise, except "
    "to obtain some advantage from it? But who has any right to find "
    "fault with a man who chooses to enjoy a pleasure that has no "
    "annoying consequences, or one who avoids a pain that produces "
    "no resultant pleasure?"
)


def ensure_eps():
    eps_path = BASE_DIR / "logo.eps"
    if not eps_path.exists():
        subprocess.run(
            ["magick", str(BASE_DIR / "logo.png"), str(eps_path)],
            check=True,
        )
    return eps_path


def load_records(xml_path: Path) -> list[dict]:
    tree = ET.parse(xml_path)
    return [elem.attrib for elem in tree.getroot().findall("record")]


def generate_groff(records: list[dict], eps_path: Path) -> str:
    lines = [
        '.\\\" groff mail-merge',
        '.pl 29.7c',
    ]

    for i, r in enumerate(records):
        if i > 0:
            lines.append('.bp')

        lines.extend([
            '.po 2c',
            '.ll 17c',
            '.fam H',
            '.ps 11',
            '.vs 16.5p',
            '.hy 1',
            '',
            '.\\\" Logo top-right',
            f'.PSPIC -R {eps_path} 3.5c',
            '.sp 0.5c',
            '',
            '.\\\" Recipient + sender side by side',
            '.TS',
            'tab(|);',
            'lw(10.5c) rw(5.5c).',
            'T{',
            f'{r["first_name"]} {r["last_name"]}',
            '.br',
            f'{r["address"]}',
            '.br',
            f'{r["city"]}, {r["state"]} {r["zip"]}',
            'T}|T{',
            '.ad r',
            '.ps 10',
            'Print Company & Office',
            '.br',
            '61556 W 20th Ave',
            '.br',
            'Seattle King WA 98104',
            '.sp 0.3c',
            '206-711-6498',
            '.br',
            '206-395-6284',
            '.sp 0.3c',
            'jbiddy@printcompany.com',
            '.br',
            'www.printcompany.com',
            'T}',
            '.TE',
            '',
            '.\\\" Letter body',
            '.ps 11',
            '.vs 16.5p',
            '.ll 10.5c',
            '.sp 2.5c',
            '.na',
            'November 6, 2014',
            '.sp 0.8c',
            f'Dear {r["first_name"]} {r["last_name"]},',
            '.sp 0.5c',
            '.ad b',
            BODY_TEXT,
            '.sp 0.5c',
            '.na',
            'Yours faithfully,',
            '.sp 1c',
            'Jani Biddy',
        ])

    return '\n'.join(lines) + '\n'


def main():
    xml_name = sys.argv[1] if len(sys.argv) > 1 else "fakenames.xml"
    records = load_records(BASE_DIR / xml_name)
    eps_path = ensure_eps()

    groff_src = generate_groff(records, eps_path)
    groff_path = BASE_DIR / "mailmerge_groff.roff"
    groff_path.write_text(groff_src, encoding="utf-8")

    pdf_path = BASE_DIR / "mailmerge_groff.pdf"
    groff_proc = subprocess.Popen(
        ["groff", "-t", "-Tps", str(groff_path)],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )
    with open(pdf_path, "wb") as pdf_file:
        subprocess.run(
            ["ps2pdf", "-", "-"],
            stdin=groff_proc.stdout,
            stdout=pdf_file,
            stderr=subprocess.DEVNULL,
            check=True,
        )
    groff_proc.wait()
    print(f"PDF generated: mailmerge_groff.pdf ({len(records)} letters)")


if __name__ == "__main__":
    main()
