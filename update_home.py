import re

with open('lib/screens/home_page.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# --- 1. Paper Trading Dialog Editable TextField ---
# I will find the definition of _showPaperTradingDialog() and replace it entirely up to its closing brace.
start_dialog = "void _showPaperTradingDialog() {"
idx_start = text.find(start_dialog)
if idx_start == -1:
    print("Could not find _showPaperTradingDialog")
else:
    # Find the closing brace of _showPaperTradingDialog
    # We will count braces.
    count = 0
    idx_end = -1
    for i in range(idx_start, len(text)):
        if text[i] == '{':
            count += 1
        elif text[i] == '}':
            count -= 1
            if count == 0:
                idx_end = i + 1
                break
    
    new_dialog = """void _showPaperTradingDialog() {
    final TextEditingController balanceController = TextEditingController(text: '100000');
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF090501),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TERMINAL • PAPER TRADING',
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close,
                        color: Colors.white54, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.edit_document, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text('PAPER TRADING SIMULATOR',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                  'Practice with virtual funds • Zero risk • Real market prices',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 32),
              const Text('STARTING BALANCE',
                  style: TextStyle(
                      color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(4)),
                child: TextField(
                  controller: balanceController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.unfold_more, color: Colors.white54, size: 16),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: border),
                            borderRadius: BorderRadius.circular(4)),
                        alignment: Alignment.center,
                        child: const Text('CANCEL',
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPaperConnected = true;
                          _paperBalance = double.tryParse(balanceController.text) ?? 100000;
                        });
                        Navigator.pop(ctx);
                        _showSuccessSnackBar();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(4)),
                        alignment: Alignment.center,
                        child: const Text('START PAPER TRADING',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
"""
    text = text[:idx_start] + new_dialog + text[idx_end:]


# --- 2. Intelligence View Tabs ---
# find _IntelligenceViewState
svars_idx = text.find('class _IntelligenceViewState extends State<IntelligenceView> {')
if svars_idx != -1:
    vars_end = text.find('{', svars_idx) + 1
    if 'String _selectedModule =' not in text[vars_end:vars_end+100]:
        text = text[:vars_end] + "\n  String _selectedModule = 'GEOINTEL';\n" + text[vars_end:]


# update _intelModuleItem function signature and tap logic
old_intel_item = """  Widget _intelModuleItem(
      String title, String subtitle, IconData icon, bool isSelected) {"""
new_intel_item = """  Widget _intelModuleItem(
      String title, String subtitle, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedModule = title),
      child: """

if old_intel_item in text:
    text = text.replace(old_intel_item, new_intel_item)
    # also we need to add standard parenthesis for the child returned by gesture detector
    # I'll just regex replace the "      child: Row(" inside
    # Wait, instead of this, I'll rewrite the intelModule calls and item.

rx_item = re.compile(
    r"Widget _intelModuleItem\(.*?String title, String subtitle, IconData icon, bool isSelected\)\s*\{.*?return Container\(.*?\}\s*,\s*\)\s*;\s*\}",
    re.DOTALL
)

new_item_full = """Widget _intelModuleItem(
      String title, String subtitle, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedModule = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00FF66).withOpacity(0.05)
              : Colors.transparent,
          border: Border.all(
              color: isSelected
                  ? const Color(0xFF00FF66).withOpacity(0.5)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF00FF66) : Colors.white54,
                size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF00FF66)
                              : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF00FF66).withOpacity(0.7)
                              : Colors.white38,
                          fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }"""

match_item = rx_item.search(text)
if match_item:
    text = text[:match_item.start()] + new_item_full + text[match_item.end():]


# replace the calls
calls_old = """_intelModuleItem(
                'GEOINTEL', 'Global Risk Matrix', Icons.language, true),
            _intelModuleItem('PATTERN INSIGHTS', 'Behavioral Detection',
                Icons.show_chart, false),
            _intelModuleItem(
                'TRADER GENOME', 'Identity Modeling', Icons.fingerprint, false),
            _intelModuleItem('COGNITIVE FITNESS', 'Psychometric Scoring',
                Icons.psychology, false),
            _intelModuleItem('AI HUB', 'Main Dashboard', Icons.memory, false),"""

calls_new = """_intelModuleItem(
                'GEOINTEL', 'Global Risk Matrix', Icons.language, _selectedModule == 'GEOINTEL'),
            _intelModuleItem('PATTERN INSIGHTS', 'Behavioral Detection',
                Icons.show_chart, _selectedModule == 'PATTERN INSIGHTS'),
            _intelModuleItem(
                'TRADER GENOME', 'Identity Modeling', Icons.fingerprint, _selectedModule == 'TRADER GENOME'),
            _intelModuleItem('COGNITIVE FITNESS', 'Psychometric Scoring',
                Icons.psychology, _selectedModule == 'COGNITIVE FITNESS'),
            _intelModuleItem('AI HUB', 'Main Dashboard', Icons.memory, _selectedModule == 'AI HUB'),"""

# due to dart formatting, exact match might fail.
calls_rx = re.compile(
    r"_intelModuleItem\(\s*'GEOINTEL',.*?_intelModuleItem\('AI HUB'..*?false\),",
    re.DOTALL
)
if calls_rx.search(text):
    text = calls_rx.sub(calls_new, text)

with open('lib/screens/home_page.dart', 'w', encoding='utf-8') as f:
    f.write(text)
print("Finished updates.")
