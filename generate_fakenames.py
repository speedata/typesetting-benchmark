#!/usr/bin/env python3
"""Generate fakenames_500.xml with 500 copies of the sample record."""

import xml.etree.ElementTree as ET
from pathlib import Path

BASE_DIR = Path(__file__).parent

tree = ET.parse(BASE_DIR / "fakenames.xml")
root = tree.getroot()
record = root.find("record")

for _ in range(499):
    ET.SubElement(root, "record", record.attrib)

tree.write(BASE_DIR / "fakenames_500.xml", encoding="unicode", xml_declaration=True)
print(f"fakenames_500.xml generated ({len(root.findall('record'))} records)")
