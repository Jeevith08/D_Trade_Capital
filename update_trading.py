import sys
import re

with open('lib/screens/home_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add new state variables to _TradingViewState
state_vars_old = """  bool _isPaperConnected = false;
  double _paperBalance = 0;
  String _selectedLot = '0.01';
  int _positionsTabIndex = 0; // 0: Open, 1: History, 2: Pending
  final List<Map<String, dynamic>> _openPositions = [];
  final List<Map<String, dynamic>> _history = [];"""

state_vars_new = """  bool _isPaperConnected = false;
  double _paperBalance = 0;
  String _selectedLot = '0.01';
  int _positionsTabIndex = 0; // 0: Open, 1: History, 2: Pending
  final List<Map<String, dynamic>> _openPositions = [];
  final List<Map<String, dynamic>> _history = [];
  
  String _selectedOrderType = 'BUY';
  double _stopLoss = 50.0;
  double _takeProfit = 100.0;
  String _selectedSignalTab = 'ALL';"""

if state_vars_old in content:
    content = content.replace(state_vars_old, state_vars_new)
else:
    print("Could not find state vars")

# 2. Modify executeTrade method to not take arguments
exec_old = """  void _executeTrade(String type) {"""
exec_new = """  void _executeTrade() {
    String type = _selectedOrderType;"""
content = content.replace(exec_old, exec_new)

# 3. Update the BUY/SELL buttons to just change state
buy_sell_rx = re.compile(
    r'Row\(\s*children:\s*\[\s*Expanded\(\s*child:\s*GestureDetector\(\s*onTap:\s*\(\)\s*=>\s*_executeTrade\(\'BUY\'\).*?▼ SELL\',\s*style.*?fontWeight:\s*FontWeight\.bold\)\),\s*\),\s*\),\s*\),\s*\],\s*\),',
    re.DOTALL
)

buy_sell_new = """Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedOrderType = 'BUY'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                        color: _selectedOrderType == 'BUY' ? const Color(0xFF00FF66) : Colors.transparent,
                        border: Border.all(color: _selectedOrderType == 'BUY' ? Colors.transparent : const Color(0xFF00FF66).withOpacity(0.3), width: 2),
                        borderRadius: BorderRadius.circular(4)),
                    alignment: Alignment.center,
                    child: Text('▲ BUY',
                        style: TextStyle(
                            color: _selectedOrderType == 'BUY' ? Colors.black : const Color(0xFF00FF66),
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedOrderType = 'SELL'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                        color: _selectedOrderType == 'SELL' ? const Color(0xFFFF0033) : Colors.transparent,
                        border: Border.all(
                            color: _selectedOrderType == 'SELL' ? Colors.transparent : const Color(0xFFFF0033).withOpacity(0.3), width: 2),
                        borderRadius: BorderRadius.circular(4)),
                    alignment: Alignment.center,
                    child: Text('▼ SELL',
                        style: TextStyle(
                            color: _selectedOrderType == 'SELL' ? Colors.black : const Color(0xFFFF0033),
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),"""

m1 = buy_sell_rx.search(content)
if m1:
    content = content[:m1.start()] + buy_sell_new + content[m1.end():]
else:
    print("Could not find buy/sell buttons")

# 4. Insert the new Execute button at the end of _buildExecuteTrade
end_exec_rx = re.compile(r"Row\(\s*children:\s*\[\s*Icon\(Icons\.circle,\s*color:\s*gold,\s*size:\s*8\),\s*SizedBox\(width:\s*8\),\s*Text\('NEURAL ANALYSIS',.*?Text\('INACTIVE',.*?\],\s*\)", re.DOTALL)
m2 = end_exec_rx.search(content)
if m2:
    execute_button_new = m2.group(0) + """,
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _executeTrade,
            child: Container(
               width: double.infinity,
               padding: const EdgeInsets.symmetric(vertical: 20),
               decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(8)),
               alignment: Alignment.center,
               child: const Text('EXECUTE TRADE', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )"""
    content = content[:m2.start()] + execute_button_new + content[m2.end():]
else:
    print("Could not find end of execute trade")

# 5. Update _customSliderRow and SL/TP sliders
slider_row_old = r"""Widget _customSliderRow\(String label, String value, Color activeColor\) \{
    return Column\(
      children: \[
        Row\(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: \[
            Text\(label.*?Text\(value.*?\]\).*?Slider\(value.*?\) \{\}\)"""

# I need to match the whole _customSliderRow function
slider_row_func_rx = re.compile(
    r'Widget _customSliderRow\(String label, String value, Color activeColor.*?\}\s*\)\s*,\s*\]\s*,\s*\)\s*;\s*\}',
    re.DOTALL
)

slider_row_func_new = """Widget _customSliderRow(String label, String value, Color activeColor, double currentVal, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: 1.5)),
            Text(value,
                style: TextStyle(
                    color: activeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 2,
            thumbColor: Colors.blueAccent,
            activeTrackColor: activeColor,
            inactiveTrackColor: border,
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(value: currentVal, min: 0.0, max: 200.0, onChanged: onChanged),
        ),
      ],
    );
  }"""

m3 = slider_row_func_rx.search(content)
if m3:
    content = content[:m3.start()] + slider_row_func_new + content[m3.end():]
else:
    print("Could not find slider row func")

# Replace calls to _customSliderRow
sl_call_rx = re.compile(r"_customSliderRow\('STOP LOSS',\s*'50 pips',\s*const Color\(0xFFFF0033\)\)")
tp_call_rx = re.compile(r"_customSliderRow\('TAKE PROFIT',\s*'100 pips',\s*gold\)")

if sl_call_rx.search(content):
    content = sl_call_rx.sub(r"_customSliderRow('STOP LOSS', '${_stopLoss.toInt()} pips', const Color(0xFFFF0033), _stopLoss, (v) => setState(() => _stopLoss = v))", content)
else:
    print("could not find SL call")

if tp_call_rx.search(content):
    content = tp_call_rx.sub(r"_customSliderRow('TAKE PROFIT', '${_takeProfit.toInt()} pips', gold, _takeProfit, (v) => setState(() => _takeProfit = v))", content)
else:
    print("could not find TP call")

# 6. Make Signal tabs functional
signals_tabs_old = """_signalTab('ALL', true),
                    _signalTab('BUY', false),
                    _signalTab('SELL', false),
                    _signalTab('ACTIVE', false),"""
signals_tabs_new = """_signalTab('ALL'),
                    _signalTab('BUY'),
                    _signalTab('SELL'),
                    _signalTab('ACTIVE'),"""
if signals_tabs_old in content:
    content = content.replace(signals_tabs_old, signals_tabs_new)
else:
    # formatted code is different usually
    sig_tab_area_rx = re.compile(r"_signalTab\('ALL',\s*true\),\s*_signalTab\('BUY',\s*false\),\s*_signalTab\('SELL',\s*false\),\s*_signalTab\('ACTIVE',\s*false\),")
    if sig_tab_area_rx.search(content):
         content = sig_tab_area_rx.sub(signals_tabs_new, content)
    else:
         print("Could not find signal tabs calls")

signal_tab_func_rx = re.compile(
    r"Widget _signalTab\(String label,\s*bool isSelected\)\s*\{.*?return.*?\}",
    re.DOTALL
)
signal_tab_func_new = """Widget _signalTab(String label) {
    bool isSelected = _selectedSignalTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSignalTab = label),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? gold : border),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  color: isSelected ? gold : Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }"""
m4 = signal_tab_func_rx.search(content)
if m4:
    content = content[:m4.start()] + signal_tab_func_new + content[m4.end():]
else:
    print("could not find signal tab func")

# 7. Add _showModifyDialog function
modify_dialog_func = """  void _showModifyDialog(Map<String, dynamic> pos) {
    double tempSl = double.tryParse(pos['sl']) ?? 50.0;
    double tempTp = double.tryParse(pos['tp']) ?? 100.0;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF090501),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: border),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MODIFY TRADE: ${pos['id']}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close, color: Colors.white54, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _customSliderRow('STOP LOSS', '${tempSl.toInt()} pips', const Color(0xFFFF0033), tempSl, (v) {
                      setDialogState(() => tempSl = v);
                    }),
                    const SizedBox(height: 24),
                    _customSliderRow('TAKE PROFIT', '${tempTp.toInt()} pips', gold, tempTp, (v) {
                      setDialogState(() => tempTp = v);
                    }),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          pos['sl'] = tempSl.toStringAsFixed(2);
                          pos['tp'] = tempTp.toStringAsFixed(2);
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text('SAVE CHANGES', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
"""
# inject right before _executeTrade
if "void _executeTrade" in content:
    content = content.replace("  void _executeTrade", modify_dialog_func + "\n  void _executeTrade")
else:
    print("could not find void _executeTrade")

# update the modify gesture detector
modify_rx = re.compile(
    r"GestureDetector\(\s*onTap:\s*\(\)\s*\{\},\s*child:\s*const Text\('modify',\s*style:\s*TextStyle\(color:\s*Colors.blueAccent,\s*fontSize:\s*11\)\),\s*\)",
    re.DOTALL
)
modify_new = """GestureDetector(
                  onTap: () => _showModifyDialog(pos),
                  child: const Text('modify', style: TextStyle(color: Colors.blueAccent, fontSize: 11)),
                )"""
m5 = modify_rx.search(content)
if m5:
    content = content[:m5.start()] + modify_new + content[m5.end():]
else:
    print("could not find modify link")

with open('lib/screens/home_page.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done updating trading logic.")
