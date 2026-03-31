import 'dart:io';

void main() {
  final file = File('lib/screens/home_page.dart');
  var content = file.readAsStringSync();

  // 1: replace TradingView with stateful class
  content = content.replaceFirst('class TradingView extends StatelessWidget {\\n  const TradingView({super.key});', '''class TradingView extends StatefulWidget {
  const TradingView({super.key});

  @override
  State<TradingView> createState() => _TradingViewState();
}

class _TradingViewState extends State<TradingView> {
  bool _isPaperConnected = false;
  double _paperBalance = 0;
  String _selectedLot = '0.01';
  int _positionsTabIndex = 0; // 0: Open, 1: History, 2: Pending
  final List<Map<String, dynamic>> _openPositions = [];
  final List<Map<String, dynamic>> _history = [];

  void _showBrokerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF090501),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: const Color(0xFF3A2500)),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TRADE WITH YOUR BROKER', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, color: Colors.white54, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Connect your broker to activate live trading', style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xFF3A2500)),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white38, size: 16),
                    SizedBox(width: 8),
                    Text('Search brokers...', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('universal', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showPaperTradingDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF100A06),
                          border: Border.all(color: const Color(0xFF3A2500)),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: [
                            Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(4)), alignment: Alignment.center, child: const Text('PA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Paper Trading', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('Virtual funds • Real', style: TextStyle(color: Colors.white38, fontSize: 10)),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF100A06),
                        border: Border.all(color: const Color(0xFF3A2500)),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(4)), alignment: Alignment.center, child: const Text('CS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CSV Upload', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Import from any broker', style: TextStyle(color: Colors.white38, fontSize: 10)),
                              ],
                            )
                          )
                        ],
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

  void _showPaperTradingDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF090501),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: const Color(0xFF3A2500)),
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
                  const Text('TERMINAL • PAPER TRADING', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, color: Colors.white54, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.edit_document, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text('PAPER TRADING SIMULATOR', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Practice with virtual funds • Zero risk • Real market prices', style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 32),
              const Text('STARTING BALANCE', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(4)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('100000', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(Icons.unfold_more, color: Colors.white54, size: 16),
                  ],
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
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF3A2500)), borderRadius: BorderRadius.circular(4)),
                        alignment: Alignment.center,
                        child: const Text('CANCEL', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
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
                          _paperBalance = 100000;
                        });
                        Navigator.pop(ctx);
                        _showSuccessSnackBar();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: const Color(0xFFFFB800), borderRadius: BorderRadius.circular(4)),
                        alignment: Alignment.center,
                        child: const Text('START PAPER TRADING', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
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

  void _showSuccessSnackBar() {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         backgroundColor: const Color(0xFF0C1B10),
         shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFF00FF66)), borderRadius: BorderRadius.circular(8)),
         content: const Row(
           children: [
             Icon(Icons.check_circle, color: Color(0xFF00FF66)),
             SizedBox(width: 12),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text('Paper Account Created!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                 Text('Starting balance: USD 100,000', style: TextStyle(color: Colors.white54, fontSize: 12)),
               ],
             )
           ],
         ),
       )
     );
  }

  void _executeTrade(String type) {
    if (!_isPaperConnected) {
       _showBrokerDialog(context);
       return;
    }
    setState(() {
      _openPositions.add({
        'id': '#P\${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        'type': type,
        'symbol': 'XAUUSD',
        'lot': _selectedLot,
        'openPrice': '4557.20',
        'current': '4554.10',
        'sl': '50.00',
        'tp': '215.00',
        'pnl': type == 'BUY' ? '+15.20' : '-12.00',
        'duration': '1m',
        'isUp': type == 'BUY',
      });
      _positionsTabIndex = 0; // jump to Open Positions tab
    });
  }

  void _closePosition(Map<String, dynamic> pos) {
    setState(() {
      _openPositions.remove(pos);
      // create history map based on pos
      final closedPos = Map<String, dynamic>.from(pos);
      closedPos['closePrice'] = closedPos['current']; 
      _history.add(closedPos);
    });
  }''');

  // Modify Bottom Tabs in `_buildChartSection`
  content = content.replaceFirst('''
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text('OPEN POSITIONS', style: TextStyle(color: gold, fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(border: Border.all(color: gold)), child: const Text('0', style: TextStyle(color: gold, fontSize: 9))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(height: 2, width: 120, color: gold),
                      ],
                    ),
                    const SizedBox(width: 24),
                    const Text('HISTORY', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 24),
                    const Text('PENDING ORDERS', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
''', '''
                    _bottomTab('OPEN POSITIONS', 0, badge: _openPositions.length.toString()),
                    const SizedBox(width: 24),
                    _bottomTab('HISTORY', 1),
                    const SizedBox(width: 24),
                    _bottomTab('PENDING ORDERS', 2),
''');

  // Replace "NO OPEN POSITIONS... SizedBox(height:48)..." logic with a new _buildPositionsList method invocation inside `_buildChartSection()`
  content = content.replaceFirst('''
          const SizedBox(height: 32),
          const Text('NO OPEN POSITIONS', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          const Text('SELECT AN ACCOUNT TO BEGIN', style: TextStyle(color: Colors.white10, fontSize: 9, letterSpacing: 1)),
          const SizedBox(height: 48),
''', '''
          _buildPositionsList(),
''');


  // `LOT SIZE` row replacement to fix 0.01 bug
  content = content.replaceFirst('''
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('LOT SIZE', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
               Text('0.01', style: TextStyle(color: gold, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _lotSizeBox('0.01', true), _lotSizeBox('0.05', false), _lotSizeBox('0.1', false), _lotSizeBox('0.2', false),
              _lotSizeBox('0.3', false), _lotSizeBox('0.5', false), _lotSizeBox('1', false), _lotSizeBox('2', false),
            ],
          ),
''', '''
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Text('LOT SIZE', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
               Text(_selectedLot, style: const TextStyle(color: gold, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _lotSizeBox('0.01'), _lotSizeBox('0.05'), _lotSizeBox('0.1'), _lotSizeBox('0.2'),
              _lotSizeBox('0.3'), _lotSizeBox('0.5'), _lotSizeBox('1'), _lotSizeBox('2'),
            ],
          ),
''');

  // _lotSizeBox modification
  content = content.replaceFirst('''
  Widget _lotSizeBox(String size, bool active) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF0C0704), border: Border.all(color: active ? gold : border), borderRadius: BorderRadius.circular(6)),
      alignment: Alignment.center,
      child: Text(size, style: TextStyle(color: active ? gold : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
''', '''
  Widget _lotSizeBox(String size) {
    final active = _selectedLot == size;
    return GestureDetector(
      onTap: () => setState(() => _selectedLot = size),
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF0C0704), border: Border.all(color: active ? gold : border), borderRadius: BorderRadius.circular(6)),
        alignment: Alignment.center,
        child: Text(size, style: TextStyle(color: active ? gold : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
      )
    );
  }
''');

  // Replace + ADD ACCOUNT block and add NO MT5 connected correctly based on _isPaperConnected
  content = content.replaceFirst('''
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(Icons.electric_bolt, color: Color(0xFFFF0033), size: 12),
                     SizedBox(width: 8),
                     Text('NO MT5 CONNECTED', style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 1)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(border: Border.all(color: border)),
                  child: const Text('+ ADD ACCOUNT', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ),
              ],
            ),
''', '''
            child: _isPaperConnected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.circle, color: Color(0xFF00FF66), size: 8),
                          SizedBox(width: 8),
                          Text('PAPER TRADING', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('DTrade Paper', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Balance: \\\$\${_paperBalance.toStringAsFixed(0)}', style: const TextStyle(color: gold, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  )
                : Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(Icons.electric_bolt, color: Color(0xFFFF0033), size: 12),
                           SizedBox(width: 8),
                           Text('NO MT5 CONNECTED', style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 1)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showBrokerDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(border: Border.all(color: border)),
                          child: const Text('+ ADD ACCOUNT', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        ),
                      ),
                    ],
                  ),
''');

  // BUY AND SELL button execution logic
  content = content.replaceFirst('''
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(color: const Color(0xFF00FF66), borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: const Text('▲ BUY', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: const Color(0xFFFF0033), width: 2), borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: const Text('▼ SELL', style: TextStyle(color: Color(0xFFFF0033), fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
''', '''
              Expanded(
                child: GestureDetector(
                  onTap: () => _executeTrade('BUY'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(color: const Color(0xFF00FF66), borderRadius: BorderRadius.circular(4)),
                    alignment: Alignment.center,
                    child: const Text('▲ BUY', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _executeTrade('SELL'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: const Color(0xFFFF0033), width: 2), borderRadius: BorderRadius.circular(4)),
                    alignment: Alignment.center,
                    child: const Text('▼ SELL', style: TextStyle(color: Color(0xFFFF0033), fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
''');

  // Inject `_bottomTab`, `_buildPositionsList`, `_positionRow`, `_historyRow` right before `// INTELLIGENCE VIEW`
  content = content.replaceFirst('''
// ---------------------------------------------------------
// INTELLIGENCE VIEW
// ---------------------------------------------------------
''', '''
  Widget _bottomTab(String title, int index, {String? badge}) {
    final active = _positionsTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _positionsTabIndex = index),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(color: active ? gold : Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), 
                  decoration: BoxDecoration(border: Border.all(color: active ? gold : Colors.white38)), 
                  child: Text(badge, style: TextStyle(color: active ? gold : Colors.white38, fontSize: 9))
                ),
              ]
            ],
          ),
          const SizedBox(height: 6),
          Container(height: 2, width: active ? 100 : 0, color: gold),
        ],
      ),
    );
  }

  Widget _buildPositionsList() {
    if (_positionsTabIndex == 0) {
      if (_openPositions.isEmpty) {
        return const Column(
          children: [
            SizedBox(height: 32),
            Text('NO OPEN POSITIONS', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            SizedBox(height: 8),
            Text('SELECT AN ACCOUNT TO BEGIN', style: TextStyle(color: Colors.white10, fontSize: 9, letterSpacing: 1)),
            SizedBox(height: 48),
          ],
        );
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: const Text('SYMBOL', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('TYPE', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('LOT', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('OPEN PRICE', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('CURRENT', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('SL', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('TP', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('FLOAT P&L', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('DURATION', style: TextStyle(color: gold, fontSize: 9))),
                const SizedBox(width: 120, child: Text('ACTIONS', style: TextStyle(color: Colors.white38, fontSize: 9), textAlign: TextAlign.right)),
              ],
            ),
          ),
          Container(height: 1, color: border),
          ..._openPositions.map((pos) => _positionRow(pos)),
          const SizedBox(height: 16),
        ],
      );
    } else if (_positionsTabIndex == 1) {
      if (_history.isEmpty) {
        return const Column(
          children: [
            SizedBox(height: 32),
            Text('NO HISTORY', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            SizedBox(height: 48),
          ],
        );
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: const Text('SYMBOL', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('TYPE', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('LOT', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('OPEN PRICE', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('CLOSE PRICE', style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(child: const Text('P&L', style: TextStyle(color: Colors.white38, fontSize: 9))),
                const SizedBox(width: 120),
              ],
            ),
          ),
          Container(height: 1, color: border),
          ..._history.map((pos) => _historyRow(pos)),
          const SizedBox(height: 16),
        ],
      );
    } else {
       return const Column(
          children: [
            SizedBox(height: 32),
            Text('NO PENDING ORDERS', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            SizedBox(height: 48),
          ],
        );
    }
  }

  Widget _positionRow(Map<String, dynamic> pos) {
    Color typeColor = pos['type'] == 'BUY' ? const Color(0xFF00FF66) : const Color(0xFFFF0033);
    Color pnlColor = pos['isUp'] ? const Color(0xFF00FF66) : const Color(0xFFFF0033);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: border))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Row(
            children: [
              Container(width: 24, height: 24, decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle), alignment: Alignment.center, child: const Text('XA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pos['symbol'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(pos['id'], style: const TextStyle(color: Colors.white38, fontSize: 9)),
                ],
              )
            ],
          )),
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: typeColor.withOpacity(0.5)), borderRadius: BorderRadius.circular(4)),
            child: Text(pos['type'], style: TextStyle(color: typeColor, fontSize: 9), textAlign: TextAlign.center),
          )),
          Expanded(child: Text(pos['lot'], style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(child: Text(pos['openPrice'], style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(child: Text(pos['current'], style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(child: Text(pos['sl'], style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(child: Text(pos['tp'], style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(child: Text(pos['pnl'], style: TextStyle(color: pnlColor, fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(child: Text(pos['duration'], style: const TextStyle(color: Colors.white54, fontSize: 11))),
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text('modify', style: TextStyle(color: Colors.blueAccent, fontSize: 11)),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _closePosition(pos),
                  child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFF0033).withOpacity(0.5)), borderRadius: BorderRadius.circular(4)),
                     child: const Text('close', style: TextStyle(color: Color(0xFFFF0033), fontSize: 11)),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _historyRow(Map<String, dynamic> pos) {
    Color typeColor = pos['type'] == 'BUY' ? const Color(0xFF00FF66) : const Color(0xFFFF0033);
    Color pnlColor = pos['isUp'] ? const Color(0xFF00FF66) : const Color(0xFFFF0033);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: border))),
      child: Row(
        children: [
           Expanded(flex: 2, child: Row(
            children: [
              Container(width: 24, height: 24, decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle), alignment: Alignment.center, child: const Text('XA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pos['symbol'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(pos['id'], style: const TextStyle(color: Colors.white38, fontSize: 9)),
                ],
              )
            ],
          )),
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: typeColor.withOpacity(0.5)), borderRadius: BorderRadius.circular(4)),
            child: Text(pos['type'], style: TextStyle(color: typeColor, fontSize: 9), textAlign: TextAlign.center),
          )),
          Expanded(child: Text(pos['lot'], style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(child: Text(pos['openPrice'], style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(child: Text(pos['closePrice'], style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(child: Text(pos['pnl'], style: TextStyle(color: pnlColor, fontSize: 11, fontWeight: FontWeight.bold))),
          const SizedBox(width: 120),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// INTELLIGENCE VIEW
// ---------------------------------------------------------
'''); // wait, I added `}` above the `// INTELLIGENCE VIEW` to close `_TradingViewState`

  file.writeAsStringSync(content);
}
