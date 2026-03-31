with open('lib/screens/home_page.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()
for i, l in enumerate(lines):
    if 'toStringAsFixed' in l:
        print(f"Line {i+1}: {repr(l)}")
