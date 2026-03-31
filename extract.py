import sys

with open('build_home.py', 'r', encoding='utf-8') as f:
    code_text = f.read()

import re

# extract just the trading_view_code
m = re.search(r'trading_view_code = """(.*?)"""\n\nfinal_content', code_text, re.DOTALL)
if m:
    with open('test_format.dart', 'w', encoding='utf-8') as f:
        f.write("import 'package:flutter/material.dart';\n" + m.group(1))
