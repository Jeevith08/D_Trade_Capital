import sys
import re

with open('lib/screens/home_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# I want to find the pattern:
#   }
# }
# 
#   Widget _bottomTab(
# And change it to just `  Widget _bottomTab(` maybe? No, the original file has:
#     );
#   }
# }
# 
#   Widget _bottomTab(String title

pattern = r"    );\s*  }\s*}\s*  Widget _bottomTab"
replacement = r"    );\n  }\n\n  Widget _bottomTab"

new_content = re.sub(pattern, replacement, content)

with open('lib/screens/home_page.dart', 'w', encoding='utf-8') as f:
    f.write(new_content)

print(f"Fixed: {content != new_content}")
