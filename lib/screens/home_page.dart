import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color bg = Color(0xFF070300);
const Color gold = Color(0xFFFFB800);
const Color border = Color(0xFF3A2500);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopTicker(),
            _buildTopNav(),
            Expanded(
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: VerticalAccentLine(),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: 900), // Wider for desktop-like feel
                      child: _buildBody(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTicker() {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: border)),
      ),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _tickerItem('BTC/USD', '67,420.30', '+2.14%', true),
            _tickerItem('ETH/USD', '3,801.55', '+1.87%', true),
            _tickerItem('EUR/USD', '1.0842', '-0.12%', false),
            _tickerItem('GBP/USD', '1.2680', '+0.34%', true),
            _tickerItem('XAU/USD', '2,380.40', '-0.06%', false),
            _tickerItem('SPX', '5,432.10', '+0.61%', true),
            _tickerItem('NASDAQ', '19,240.20', '+0.92%', true),
            _tickerItem('NQ/F', '19,287.00', '+1.04%', true),
          ],
        ),
      ),
    );
  }

  Widget _tickerItem(String pair, String price, String change, bool isUp) {
    final color = isUp ? const Color(0xFF00FF66) : const Color(0xFFFF0033);
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(pair,
              style: const TextStyle(
                  color: gold, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(price,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(width: 8),
          Text(change,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: gold)),
                    child: const Text('D',
                        style: TextStyle(
                            color: gold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  const Text('TERMINAL',
                      style: TextStyle(
                          color: gold,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Builder(builder: (ctx) {
                final u = FirebaseAuth.instance.currentUser;
                final name = u?.displayName ?? u?.email ?? 'ME';
                final initials = name.length >= 2
                    ? name.substring(0, 2).toUpperCase()
                    : 'ME';
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: gold),
                  ),
                  alignment: Alignment.center,
                  child: Text(initials,
                      style: const TextStyle(
                          color: gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                );
              }),
            ],
          ),
        ),
        // Tabs Container
        Container(
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF090501),
            border: Border(bottom: BorderSide(color: border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navTab('TRADING', 0),
              _navTab('INTELLIGENCE', 1),
              _navTab('ACCOUNT', 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _navTab(String label, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _currentIndex = index),
          behavior: HitTestBehavior.opaque,
          child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: isSelected ? gold : Colors.transparent,
                      width: 2))),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? gold : Colors.white54,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 1.0,
            ),
            ),
          ),
        ),
      ),
    );
  }

  // Legacy buttons removed for app view

  Widget _buildBody() {
    final idx = _currentIndex == 3 ? 0 : _currentIndex;
    switch (idx) {
      case 0:
        return const TradingView();
      case 1:
        return const IntelligenceView();
      case 2:
      default:
        return const AccountView();
    }
  }
}

// ---------------------------------------------------------
// TRADING VIEW
// ---------------------------------------------------------
class TradingView extends StatefulWidget {
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

  String _selectedOrderType = 'BUY';
  double _stopLoss = 50.0;
  double _takeProfit = 100.0;
  String _selectedSignalTab = 'ALL';

  void _showBrokerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF090501),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
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
                  const Text('TRADE WITH YOUR BROKER',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close,
                          color: Colors.white54, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Connect your broker to activate live trading',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white38, size: 16),
                    SizedBox(width: 8),
                    Text('Search brokers...',
                        style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('universal',
                  style: TextStyle(
                      color: Colors.white38, fontSize: 10, letterSpacing: 2)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          _showPaperTradingDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: const Color(0xFF100A06),
                              border: Border.all(color: border),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(4)),
                                  alignment: Alignment.center,
                                  child: const Text('PA',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Paper Trading',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('Virtual funds • Real',
                                        style: TextStyle(
                                            color: Colors.white38, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: const Color(0xFF100A06),
                              border: Border.all(color: border),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(4)),
                                  alignment: Alignment.center,
                                  child: const Text('CS',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CSV Upload',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('Import from any broker',
                                        style: TextStyle(
                                            color: Colors.white38, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
    final TextEditingController balanceController = TextEditingController(text: '100000');
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                    const Text('TERMINAL • PAPER TRADING',
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5)),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Icon(Icons.close,
                            color: Colors.white54, size: 18),
                      ),
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
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(4)),
                  child: TextField(
                    controller: balanceController,
                    autofocus: true,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  double current =
                                      double.tryParse(balanceController.text) ??
                                          0;
                                  balanceController.text =
                                      (current + 1000).toInt().toString();
                                },
                                child: const Icon(Icons.keyboard_arrow_up,
                                    color: gold, size: 18),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  double current =
                                      double.tryParse(balanceController.text) ??
                                          0;
                                  if (current >= 1000) {
                                    balanceController.text =
                                        (current - 1000).toInt().toString();
                                  }
                                },
                                child: const Icon(Icons.keyboard_arrow_down,
                                    color: gold, size: 18),
                              ),
                            ),
                          ],
                        ),
                        hintText: 'Enter balance...',
                        hintStyle: const TextStyle(color: Colors.white12)),
                    cursorColor: gold,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPaperConnected = true;
                              _paperBalance =
                                  double.tryParse(balanceController.text) ??
                                      100000;
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color(0xFF0C1B10),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: const Color(0xFF00FF66)),
          borderRadius: BorderRadius.circular(8)),
      content: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF00FF66)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Paper Account Created!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text('Starting balance: USD 100,000',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          )
        ],
      ),
    ));
  }

  void _showModifyDialog(Map<String, dynamic> pos) {
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
                        Text('MODIFY TRADE: ${pos['id']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: const Icon(Icons.close,
                                color: Colors.white54, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _customSliderRow('STOP LOSS', '${tempSl.toInt()} pips',
                        const Color(0xFFFF0033), tempSl, (v) {
                      setDialogState(() => tempSl = v);
                    }),
                    const SizedBox(height: 24),
                    _customSliderRow(
                        'TAKE PROFIT', '${tempTp.toInt()} pips', gold, tempTp,
                        (v) {
                      setDialogState(() => tempTp = v);
                    }),
                    const SizedBox(height: 32),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
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
                          decoration: BoxDecoration(
                              color: gold,
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: const Text('SAVE CHANGES',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
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

  void _executeTrade() {
    String type = _selectedOrderType;
    if (!_isPaperConnected) {
      _showBrokerDialog(context);
      return;
    }
    setState(() {
      _openPositions.add({
        'id': '#P' +
            DateTime.now().millisecondsSinceEpoch.toString().substring(5),
        'type': type,
        'symbol': 'XAUUSD',
        'lot': _selectedLot,
        'openPrice': '4557.20',
        'current': '4554.10',
        'sl': _stopLoss.toStringAsFixed(2),
        'tp': _takeProfit.toStringAsFixed(2),
        'pnl': type == 'BUY' ? '+15.20' : '-12.00',
        'duration': '1m',
        'isUp': type == 'BUY',
      });
      _positionsTabIndex = 0; // jump to Open Positions tab
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color(0xFF0C1B10),
      duration: const Duration(seconds: 2),
      content: const Row(
        children: [
          Icon(Icons.bolt, color: gold),
          SizedBox(width: 12),
          Text('Trade Executed!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    ));
  }

  void _closePosition(Map<String, dynamic> pos) {
    setState(() {
      _openPositions.remove(pos);
      // create history map based on pos
      final closedPos = Map<String, dynamic>.from(pos);
      closedPos['closePrice'] = closedPos['current'];
      _history.add(closedPos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _buildMarketWatch(),
        const SizedBox(height: 16),
        _buildSignals(),
        const SizedBox(height: 16),
        _buildAIAlerts(),
        const SizedBox(height: 24),
        _buildChartSection(),
        const SizedBox(height: 24),
        _buildExecuteTrade(),
      ],
    );
  }

  Widget _buildMarketWatch() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.diamond, color: gold, size: 14),
                    SizedBox(width: 8),
                    Text('MARKET WATCH',
                        style: TextStyle(
                            color: gold,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('+ ADD',
                      style: TextStyle(
                          color: gold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(height: 1, color: border),
          _marketWatchItem(
              'EU', Colors.blueAccent, 'EUR/USD', '1.0724', '-0.80%', false),
          _marketWatchItem('GB', Colors.deepPurpleAccent, 'GBP/USD', '1.2624',
              '-0.40%', false),
          _marketWatchItem(
              'US', Colors.white24, 'USD/JPY', '152.84', '+1.48%', true),
        ],
      ),
    );
  }

  Widget _marketWatchItem(String label, Color avatarColor, String pair,
      String price, String change, bool isUp) {
    final color = isUp ? const Color(0xFF00FF66) : const Color(0xFFFF0033);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF100A06), // slightly elevated background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration:
                    BoxDecoration(color: avatarColor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text(pair,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(change, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignals() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: gold, width: 2))),
              const SizedBox(width: 8),
              const Text('SIGNALS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              const Text('Click to view',
                  style: TextStyle(color: Colors.white38, fontSize: 10)),
              const Spacer(),
              _badge('4 TOTAL', Colors.white24),
              const SizedBox(width: 4),
              _badge('0 ACTIVE', Colors.white24),
              const SizedBox(width: 4),
              _badge('4 PASSED', const Color(0xFF00FF66)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _signalTab('ALL'),
              _signalTab('BUY'),
              _signalTab('SELL'),
              _signalTab('ACTIVE'),
            ],
          ),
          const SizedBox(height: 16),
          _signalRow('SELL', 'XAU/USD', 'HIGH', const Color(0xFFFF0033)),
          _signalRow('SELL', 'XAU/USD', 'HIGH', const Color(0xFFFF0033)),
          _signalRow('BUY', 'XAU/USD', 'LOW', const Color(0xFF00FF66)),
          _signalRow('BUY', 'XAU/USD', 'MEDIUM', gold),
        ],
      ),
    );
  }

  Widget _badge(String text, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(text, style: TextStyle(color: borderColor, fontSize: 9)),
    );
  }

  Widget _signalTab(String label) {
    bool isSelected = _selectedSignalTab == label;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
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
      ),
    );
  }

  Widget _signalRow(String type, String pair, String conf, Color outlineColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: outlineColor.withOpacity(0.5))),
                child: Text(type,
                    style: TextStyle(
                        color: outlineColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text(pair,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: outlineColor.withOpacity(0.5))),
                child: Text(conf,
                    style: TextStyle(
                        color: outlineColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xFF00FF66).withOpacity(0.5))),
                child: const Text('PASSED',
                    style: TextStyle(
                        color: Color(0xFF00FF66),
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAIAlerts() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF090501), border: Border.all(color: border)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.electric_bolt, color: gold, size: 16),
              SizedBox(width: 8),
              Text('AI ALERTS',
                  style: TextStyle(
                      color: gold, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0033).withOpacity(0.05),
              border:
                  Border.all(color: const Color(0xFFFF0033).withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Revenge pattern detected',
                    style: TextStyle(
                        color: Color(0xFFFF0033),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('04:41',
                    style: TextStyle(color: Colors.white24, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF090501), border: Border.all(color: border)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: gold, size: 10),
                    SizedBox(width: 8),
                    Text('XAU/USD',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('PRICING',
                        style: TextStyle(color: Colors.white38, fontSize: 9)),
                    SizedBox(height: 4),
                    Text('– 0.00%',
                        style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 1, color: border),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _chartTab('1m', true),
                    _chartTab('5m', false),
                    _chartTab('15m', false),
                    _chartTab('1H', false),
                    _chartTab('4H', false),
                    _chartTab('1D', false),
                  ],
                ),
                const Row(
                  children: [
                    Text('SPREAD —',
                        style: TextStyle(color: Colors.white38, fontSize: 10)),
                    SizedBox(width: 8),
                    Icon(Icons.circle, color: Color(0xFF00FF66), size: 8),
                    SizedBox(width: 4),
                    Text('LIVE',
                        style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.show_chart, color: Colors.white10, size: 60),
                Positioned(
                  right: 12,
                  top: 40,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: const Color(0xFF00FF66).withOpacity(0.2),
                    child: const Text('4,429.915',
                        style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 40,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: const Color(0xFF00FF66).withOpacity(0.2),
                    child: const Text('1.14K',
                        style: TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: border),
          // Chart Bottom Tabs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _bottomTab('OPEN POSITIONS', 0,
                        badge: _openPositions.length.toString()),
                    const SizedBox(width: 24),
                    _bottomTab('HISTORY', 1),
                    const SizedBox(width: 24),
                    _bottomTab('PENDING ORDERS', 2),
                  ],
                ),
                Row(
                  children: [
                    _filterTab('ALL', true),
                    _filterTab('BUY', false),
                    _filterTab('SELL', false),
                  ],
                ),
              ],
            ),
          ),
          _buildPositionsList(),
        ],
      ),
    );
  }

  Widget _chartTab(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(
              color: active ? const Color(0xFF00FF66) : Colors.transparent)),
      child: Text(text,
          style: TextStyle(
              color: active ? const Color(0xFF00FF66) : Colors.white54,
              fontSize: 11)),
    );
  }

  Widget _filterTab(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(border: Border.all(color: active ? gold : border)),
      child: Text(text,
          style:
              TextStyle(color: active ? gold : Colors.white38, fontSize: 10)),
    );
  }

  Widget _buildExecuteTrade() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF090501), border: Border.all(color: border)),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.electric_bolt, color: gold, size: 16),
              SizedBox(width: 8),
              Text('EXECUTE TRADE',
                  style: TextStyle(
                      color: gold, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: const Color(0xFF100A06),
                borderRadius: BorderRadius.circular(12)),
            child: _isPaperConnected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.circle, color: Color(0xFF00FF66), size: 8),
                          SizedBox(width: 8),
                          Text('PAPER TRADING',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('DTrade Paper®',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Balance: \$' + _paperBalance.toStringAsFixed(0),
                          style: const TextStyle(
                              color: gold,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                : Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.electric_bolt,
                              color: Color(0xFFFF0033), size: 12),
                          SizedBox(width: 8),
                          Text('NO MT5 CONNECTED',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                  letterSpacing: 1)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _showBrokerDialog(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: border)),
                            child: const Text('+ ADD ACCOUNT',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: _selectedOrderType == 'BUY'
                      ? const Color(0xFF00FF66)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () => setState(() => _selectedOrderType = 'BUY'),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedOrderType == 'BUY'
                                  ? Colors.transparent
                                  : const Color(0xFF00FF66).withOpacity(0.3),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(4)),
                      alignment: Alignment.center,
                      child: Text('▲ BUY',
                          style: TextStyle(
                              color: _selectedOrderType == 'BUY'
                                  ? Colors.black
                                  : const Color(0xFF00FF66),
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Material(
                  color: _selectedOrderType == 'SELL'
                      ? const Color(0xFFFF0033)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () => setState(() => _selectedOrderType = 'SELL'),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedOrderType == 'SELL'
                                  ? Colors.transparent
                                  : const Color(0xFFFF0033).withOpacity(0.3),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(4)),
                      alignment: Alignment.center,
                      child: Text('▼ SELL',
                          style: TextStyle(
                              color: _selectedOrderType == 'SELL'
                                  ? Colors.black
                                  : const Color(0xFFFF0033),
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('LOT SIZE',
                  style: TextStyle(
                      color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
              Text(_selectedLot,
                  style: const TextStyle(
                      color: gold, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _lotSizeBox('0.01'),
              _lotSizeBox('0.05'),
              _lotSizeBox('0.1'),
              _lotSizeBox('0.2'),
              _lotSizeBox('0.3'),
              _lotSizeBox('0.5'),
              _lotSizeBox('1'),
              _lotSizeBox('2'),
            ],
          ),
          const SizedBox(height: 32),
          _customSliderRow(
              'STOP LOSS',
              '${_stopLoss.toInt()} pips',
              const Color(0xFFFF0033),
              _stopLoss,
              (v) => setState(() => _stopLoss = v)),
          const SizedBox(height: 24),
          _customSliderRow('TAKE PROFIT', '${_takeProfit.toInt()} pips', gold,
              _takeProfit, (v) => setState(() => _takeProfit = v)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
                color: const Color(0xFF0C0704),
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(8)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Text('RISK',
                      style: TextStyle(color: Colors.white54, fontSize: 10)),
                  SizedBox(height: 8),
                  Text('0.0%',
                      style: TextStyle(
                          color: Color(0xFFFF0033),
                          fontSize: 13,
                          fontWeight: FontWeight.bold))
                ]),
                Column(children: [
                  Text('REWARD',
                      style: TextStyle(color: Colors.white54, fontSize: 10)),
                  SizedBox(height: 8),
                  Text('0.0%',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold))
                ]),
                Column(children: [
                  Text('RATIO',
                      style: TextStyle(color: Colors.white54, fontSize: 10)),
                  SizedBox(height: 8),
                  Text('1:2.0',
                      style: TextStyle(
                          color: gold,
                          fontSize: 13,
                          fontWeight: FontWeight.bold))
                ]),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.circle, color: gold, size: 8),
                SizedBox(width: 8),
                Text('NEURAL ANALYSIS',
                    style: TextStyle(
                        color: Colors.white54, fontSize: 10, letterSpacing: 1))
              ]),
              Text('INACTIVE',
                  style: TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 32),
          Material(
            color: gold,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: _executeTrade,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: const Text('EXECUTE TRADE',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lotSizeBox(String size) {
    final active = _selectedLot == size;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedLot = size),
        child: Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: const Color(0xFF0C0704),
              border: Border.all(color: active ? gold : border),
              borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.center,
          child: Text(size,
              style: TextStyle(
                  color: active ? gold : Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _customSliderRow(String label, String value, Color activeColor,
      double currentVal, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
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
            thumbColor: Colors
                .blueAccent, // matching standard blue thumb from screenshot
            activeTrackColor: activeColor,
            inactiveTrackColor: border,
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
              value: currentVal, min: 0.0, max: 1000.0, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _bottomTab(String title, int index, {String? badge}) {
    final active = _positionsTabIndex == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _positionsTabIndex = index),
        child: Column(
          children: [
            Row(
              children: [
                Text(title,
                    style: TextStyle(
                        color: active ? gold : Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: active ? gold : Colors.white38)),
                      child: Text(badge,
                          style: TextStyle(
                              color: active ? gold : Colors.white38,
                              fontSize: 9))),
                ]
              ],
            ),
            const SizedBox(height: 6),
            Container(height: 2, width: active ? 100 : 0, color: gold),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionsList() {
    if (_positionsTabIndex == 0) {
      if (_openPositions.isEmpty) {
        return const Column(
          children: [
            SizedBox(height: 32),
            Text('NO OPEN POSITIONS',
                style: TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
            SizedBox(height: 8),
            Text('SELECT AN ACCOUNT TO BEGIN',
                style: TextStyle(
                    color: Colors.white10, fontSize: 9, letterSpacing: 1)),
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
                Expanded(
                    flex: 2,
                    child: const Text('SYMBOL',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('TYPE',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('LOT',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('OPEN PRICE',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('CURRENT',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('SL',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('TP',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('FLOAT P&L',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('DURATION',
                        style: TextStyle(color: gold, fontSize: 9))),
                const SizedBox(
                    width: 120,
                    child: Text('ACTIONS',
                        style: TextStyle(color: Colors.white38, fontSize: 9),
                        textAlign: TextAlign.right)),
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
            Text('NO HISTORY',
                style: TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
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
                Expanded(
                    flex: 2,
                    child: const Text('SYMBOL',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('TYPE',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('LOT',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('OPEN PRICE',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('CLOSE PRICE',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
                Expanded(
                    child: const Text('P&L',
                        style: TextStyle(color: Colors.white38, fontSize: 9))),
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
          Text('NO PENDING ORDERS',
              style: TextStyle(
                  color: Colors.white24,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          SizedBox(height: 48),
        ],
      );
    }
  }

  Widget _positionRow(Map<String, dynamic> pos) {
    Color typeColor = pos['type'] == 'BUY'
        ? const Color(0xFF00FF66)
        : const Color(0xFFFF0033);
    Color pnlColor =
        pos['isUp'] ? const Color(0xFF00FF66) : const Color(0xFFFF0033);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                          color: Colors.white12, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text('XA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pos['symbol'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Text(pos['id'],
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 9)),
                    ],
                  )
                ],
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(color: typeColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(4)),
            child: Text(pos['type'],
                style: TextStyle(color: typeColor, fontSize: 9),
                textAlign: TextAlign.center),
          )),
          Expanded(
              child: Text(pos['lot'],
                  style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(
              child: Text(pos['openPrice'],
                  style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(
              child: Text(pos['current'],
                  style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(
              child: Text(pos['sl'],
                  style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(
              child: Text(pos['tp'],
                  style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(
              child: Text(pos['pnl'],
                  style: TextStyle(
                      color: pnlColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          Expanded(
              child: Text(pos['duration'],
                  style: const TextStyle(color: Colors.white54, fontSize: 11))),
          SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showModifyDialog(pos),
                      child: const Text('modify',
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _closePosition(pos),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFFF0033).withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('close',
                            style: TextStyle(
                                color: Color(0xFFFF0033), fontSize: 11)),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _historyRow(Map<String, dynamic> pos) {
    Color typeColor = pos['type'] == 'BUY'
        ? const Color(0xFF00FF66)
        : const Color(0xFFFF0033);
    Color pnlColor =
        pos['isUp'] ? const Color(0xFF00FF66) : const Color(0xFFFF0033);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                          color: Colors.white12, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text('XA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pos['symbol'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Text(pos['id'],
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 9)),
                    ],
                  )
                ],
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(color: typeColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(4)),
            child: Text(pos['type'],
                style: TextStyle(color: typeColor, fontSize: 9),
                textAlign: TextAlign.center),
          )),
          Expanded(
              child: Text(pos['lot'],
                  style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(
              child: Text(pos['openPrice'],
                  style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(
              child: Text(pos['closePrice'],
                  style: const TextStyle(color: Colors.white, fontSize: 11))),
          Expanded(
              child: Text(pos['pnl'],
                  style: TextStyle(
                      color: pnlColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          const SizedBox(width: 120),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
class IntelligenceView extends StatefulWidget {
  const IntelligenceView({super.key});

  @override
  State<IntelligenceView> createState() => _IntelligenceViewState();
}

class _IntelligenceViewState extends State<IntelligenceView> {
  String _selectedModule = 'GEOINTEL';

  bool _showModules = false;

  Widget _buildGeoIntelContent(bool isWide) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildActiveHotspots(),
                const SizedBox(height: 16),
                _buildRegionalIndices(),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _buildMapArea(),
                const SizedBox(height: 16),
                _buildAIGeneratedSignals(),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildMapArea(),
          const SizedBox(height: 16),
          _buildActiveHotspots(),
          const SizedBox(height: 16),
          _buildRegionalIndices(),
          const SizedBox(height: 16),
          _buildAIGeneratedSignals(),
        ],
      );
    }
  }

  Widget _buildPlaceholderContent(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF00FF66), size: 48),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 32),
          // Dummy graphs/stats for placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (i) => Container(
                      width: 40,
                      height: 100 * (i + 1) / 5,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFF00FF66).withOpacity(0.3 + (i * 0.1)),
                          borderRadius: BorderRadius.circular(4)),
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleContent(bool isWide) {
    switch (_selectedModule) {
      case 'GEOINTEL':
        return _buildGeoIntelContent(isWide);
      case 'PATTERN INSIGHTS':
        return _buildPlaceholderContent('PATTERN INSIGHTS',
            'Real-time behavioral detection and pattern matching algorithm active.', Icons.show_chart);
      case 'TRADER GENOME':
        return _buildPlaceholderContent('TRADER GENOME',
            'Identity modeling and historical emotional bias analysis.', Icons.fingerprint);
      case 'COGNITIVE FITNESS':
        return _buildPlaceholderContent('COGNITIVE FITNESS',
            'Decision fatigue metrics and psychometric performance scoring.', Icons.psychology);
      default:
        return _buildGeoIntelContent(isWide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 750;
        if (isWide) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 240,
                  child: _buildIntelModules(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildTopStats(),
                      const SizedBox(height: 16),
                      _buildModuleContent(true),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              _buildIntelModules(),
              const SizedBox(height: 24),
              _buildTopStats(),
              const SizedBox(height: 24),
              _buildModuleContent(false),
            ],
          );
        }
      },
    );
  }

  Widget _buildIntelModules() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0704),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showModules = !_showModules;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.track_changes,
                          color: Color(0xFF00FF66), size: 18),
                      SizedBox(width: 12),
                      Text('INTEL MODULES',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                    ],
                  ),
                  Icon(
                      _showModules
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white54),
                ],
              ),
            ),
          ),
          if (_showModules) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: border),
            const SizedBox(height: 16),
            _intelModuleItem(
                'GEOINTEL', 'Global Risk Matrix', Icons.language, _selectedModule == 'GEOINTEL'),
            _intelModuleItem('PATTERN INSIGHTS', 'Behavioral Detection',
                Icons.show_chart, _selectedModule == 'PATTERN INSIGHTS'),
            _intelModuleItem(
                'TRADER GENOME', 'Identity Modeling', Icons.fingerprint, _selectedModule == 'TRADER GENOME'),
            _intelModuleItem('COGNITIVE FITNESS', 'Psychometric Scoring',
                Icons.psychology, _selectedModule == 'COGNITIVE FITNESS'),
            _intelModuleItem('AI HUB', 'Main Dashboard', Icons.memory, _selectedModule == 'AI HUB'),
          ],
        ],
      ),
    );
  }

  Widget _intelModuleItem(
      String title, String subtitle, IconData icon, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
      ),
    );
  }

  Widget _buildTopStats() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: border),
                color: const Color(0xFF0C0704),
              ),
              child: const Row(
                children: [
                  Text('GLOBAL TENSION INDEX',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 1.5)),
                  SizedBox(width: 16),
                  Text('71.4',
                      style: TextStyle(
                          color: gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _topTab('MAP', true),
                    _topTab('NEWS', false),
                    _topTab('CALENDAR', false),
                    _topTab('SIGNALS', false),
                    _topTab('MATRIX', false),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _statusBarItem('AI ANALYTICS', 'ONLINE', const Color(0xFF00FF66)),
              _statusBarItem('ACTIVE SIGNALS', '5', gold),
              _statusBarItem('HOTSPOTS', '9 CRITICAL', const Color(0xFFFF0033)),
              _statusBarItem('NEWS FEEDS', 'ACTIVE', const Color(0xFF00FF66)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: border),
      ],
    );
  }

  Widget _topTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF100A06) : Colors.transparent,
        border: Border(
            bottom: BorderSide(
                color: isSelected ? gold : Colors.transparent, width: 2)),
      ),
      child: Text(label,
          style: TextStyle(
              color: isSelected ? gold : Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1)),
    );
  }

  Widget _statusBarItem(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          const SizedBox(width: 8),
          Text(value,
              style: TextStyle(
                  color: valueColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActiveHotspots() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ACTIVE HOTSPOTS',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF0033).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('9',
                      style: TextStyle(
                          color: Color(0xFFFF0033),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(height: 1, color: border),
          _hotspotItem('WAR/GEO • IRAN', 'Hormuz Blockade', 88),
          _hotspotItem('WAR/GEO • UKRAINE', 'Drone Campaign', 82),
          _hotspotItem('WAR/GEO • RUSSIA', 'Sanctions Expand', 85),
          _hotspotItem('WAR/GEO • NORTH KOREA', 'Missile Launch', 79),
          _hotspotItem('WAR/GEO • ISRAEL', 'Regional Tension', 76),
        ],
      ),
    );
  }

  Widget _hotspotItem(String category, String title, int score) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category,
              style: const TextStyle(
                  color: Color(0xFFFF0033),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('RISK SCORE:',
                  style: TextStyle(color: Colors.white38, fontSize: 10)),
              const SizedBox(width: 8),
              Text(score.toString(),
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalIndices() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('REGIONAL INDICES',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 16),
          _indexBar('Iran', 0.88, 88),
          _indexBar('Yemen', 0.85, 85),
          _indexBar('Russia', 0.85, 85),
          _indexBar('Syria', 0.80, 80),
          _indexBar('Ukraine', 0.78, 78),
        ],
      ),
    );
  }

  Widget _indexBar(String region, double frac, int val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
              width: 60,
              child: Text(region,
                  style: const TextStyle(color: Colors.white54, fontSize: 11))),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(2)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: frac,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF0033),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
              width: 24,
              child: Text(val.toString(),
                  style: const TextStyle(
                      color: Color(0xFFFF0033),
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          const Center(
              child: Icon(Icons.public, color: Colors.white10, size: 100)),
          Positioned(top: 60, left: 120, child: _node(const Color(0xFFFF0033))),
          Positioned(bottom: 80, right: 100, child: _node(gold)),
          Positioned(
              top: 80, right: 140, child: _node(const Color(0xFFFF0033))),
          Positioned(
              top: 100, left: 180, child: _node(const Color(0xFF00FF66))),
          Positioned(bottom: 100, left: 80, child: _node(Colors.blueAccent)),
        ],
      ),
    );
  }

  Widget _node(Color c) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: c.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: c.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)
        ],
      ),
    );
  }

  Widget _buildAIGeneratedSignals() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: gold, size: 8),
                  SizedBox(width: 8),
                  Text('AI INTELLIGENCE',
                      style: TextStyle(
                          color: gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFF00FF66), size: 8),
                  SizedBox(width: 4),
                  Text('READY',
                      style: TextStyle(
                          color: Color(0xFF00FF66),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.05),
              border: const Border(left: BorderSide(color: gold, width: 3)),
            ),
            child: const Text(
              'Institutional flow identifies dual-front escalation scenario. BRENT targeting \$90 range; favors XAU/USD. Max EUR divergence identified.',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                  fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 24),
          const Text('GENERATED SIGNALS',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.05),
              border: Border.all(color: gold.withOpacity(0.2)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: gold, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Long-term AI directional bias — for educational purposes only. Not financial advice. Not for short-term trading.',
                    style: TextStyle(color: gold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _signalCard('XAU/USD', 'BUY', 'LONG-TERM', '85%',
              'Rising conflict and Fed dovish pivot increases safe haven demand for gold'),
          _signalCard('EUR/USD', 'SELL', 'LONG-TERM', '78%',
              'ECB cuts while Fed holds steady creates primary bearish pressure'),
          _signalCard('USD/JPY', 'BUY', 'LONG-TERM', '71%',
              'BOJ maintain neutral stance as DXY strength continues'),
        ],
      ),
    );
  }

  Widget _signalCard(
      String pair, String action, String term, String conf, String desc) {
    final isBuy = action == 'BUY';
    final col = isBuy ? const Color(0xFF00FF66) : const Color(0xFFFF0033);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pair,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(action,
                  style: TextStyle(
                      color: col, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(term,
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 10, letterSpacing: 1)),
              const Text(' • ',
                  style: TextStyle(color: Colors.white38, fontSize: 10)),
              Text('CONF: $conf',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 10, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 12),
          Text(desc,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// ACCOUNT VIEW
// ---------------------------------------------------------
// ---------------------------------------------------------
// ACCOUNT VIEW
// ---------------------------------------------------------
class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  bool _t1 = true;
  bool _t2 = true;
  bool _t3 = true;
  bool _t4 = true;
  bool _t5 = false;

  bool _showSystemMenu = false;
  String _selectedMenu = 'PROFILE SETTINGS';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? 'New Trader');
    _emailCtrl =
        TextEditingController(text: _user?.email ?? 'unknown@example.com');
    _phoneCtrl = TextEditingController(text: '+91 ');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_user != null) {
      await _user.updateDisplayName(_nameCtrl.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            backgroundColor: gold,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      children: [
        _buildAccountSystemMenu(),
        const SizedBox(height: 24),
        if (_selectedMenu == 'PROFILE SETTINGS') ...[
          _buildHeader(),
          const SizedBox(height: 24),
          _buildPersonalInfo(),
          const SizedBox(height: 24),
          _buildPreferences(),
          const SizedBox(height: 24),
          _buildDangerZone(),
        ] else if (_selectedMenu == 'NOTIFICATIONS') ...[
          _buildHeader(
              customTitle: 'NOTIFICATIONS',
              customSubtitle: 'Manage how and when you receive alerts'),
          const SizedBox(height: 24),
          _buildNotifications(),
        ] else if (_selectedMenu == 'SUBSCRIPTION' ||
            _selectedMenu == 'PAYMENT HISTORY' ||
            _selectedMenu == 'VERIFY PAYMENT') ...[
          _buildHeader(
              customTitle: 'BILLING & PAYMENTS',
              customSubtitle: 'Manage your active plans and records'),
          const SizedBox(height: 24),
          _buildBilling(),
        ] else if (_selectedMenu == 'COMMUNITY') ...[
          _placeholderPanel('COMMUNITY & FORUMS',
              'Community access is currently restricted to verified tier 2 traders. Features will unlock based on your activity.'),
        ] else if (_selectedMenu == 'SUPPORT') ...[
          _buildLegal(),
          const SizedBox(height: 24),
          _placeholderPanel(
              'SUPPORT TICKETS', 'You have 0 active support tickets.'),
        ],
      ],
    );
  }

  Widget _placeholderPanel(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: gold, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(subtitle,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildAccountSystemMenu() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0704),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showSystemMenu = !_showSystemMenu;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.settings, color: gold, size: 20),
                      SizedBox(width: 12),
                      Text('ACCOUNT SYSTEM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                    ],
                  ),
                  Icon(
                      _showSystemMenu
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white54),
                ],
              ),
            ),
          ),
          if (_showSystemMenu) ...[
            const SizedBox(height: 24),
            Container(height: 1, color: border),
            const SizedBox(height: 24),
            _menuGroup('NETWORK'),
            _menuItem(
                Icons.people_outline, 'COMMUNITY', 'Announcements & Forums'),
            const SizedBox(height: 24),
            _menuGroup('BILLING'),
            _menuItem(
                Icons.shield_outlined, 'SUBSCRIPTION', 'Manage Your Plan'),
            _menuItem(
                Icons.receipt_long, 'PAYMENT HISTORY', 'Invoices & Records'),
            _menuItem(
                Icons.credit_card, 'VERIFY PAYMENT', 'Submit Crypto TXID'),
            const SizedBox(height: 24),
            _menuGroup('PREFERENCES'),
            _menuItem(Icons.settings_outlined, 'PROFILE SETTINGS',
                'Security & Details'),
            _menuItem(
                Icons.notifications_none, 'NOTIFICATIONS', 'Alert Preferences'),
            _menuItem(Icons.help_outline, 'SUPPORT', 'Help Tickets'),
          ],
        ],
      ),
    );
  }

  Widget _menuGroup(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16),
      child: Text(title,
          style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5)),
    );
  }

  Widget _menuItem(IconData icon, String title, String subtitle) {
    final bool isSelected = _selectedMenu == title;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMenu = title;
            // Uncomment below if you want the menu to auto-collapse upon selection
            // _showSystemMenu = false;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F0A06) : Colors.transparent,
            border: isSelected
                ? Border.all(color: gold.withOpacity(0.5))
                : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? gold : Colors.white54, size: 22),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: isSelected ? gold : Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: isSelected
                              ? gold.withOpacity(0.7)
                              : Colors.white38,
                          fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      {String customTitle = 'PROFILE & SETTINGS',
      String customSubtitle = 'Manage your account preferences'}) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF100A06),
            border: Border.all(color: gold.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_outline, color: gold, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(customSubtitle,
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _cardWrapper(
      {required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: gold, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _cardWrapper(
      icon: Icons.person_outline,
      title: 'PERSONAL INFORMATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _inputField('FULL NAME', _nameCtrl, null, readOnly: false),
          const SizedBox(height: 16),
          _inputField('EMAIL ADDRESS', _emailCtrl, _zeroBadge(),
              readOnly: true),
          const SizedBox(height: 16),
          _inputField('Phone Number', _phoneCtrl, _indiaFlag(),
              isPrefix: true, readOnly: false),
          const SizedBox(height: 24),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _saveChanges,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('SAVE CHANGES',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _zeroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: gold.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text('ZERO',
          style: TextStyle(
              color: gold, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _indiaFlag() {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      child: const Text('🇮🇳', style: TextStyle(fontSize: 14)),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, Widget? extra,
      {bool isPrefix = false, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0C0704),
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (isPrefix && extra != null) ...[
                extra,
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down,
                    color: Colors.white38, size: 16),
                const SizedBox(width: 8)
              ],
              Expanded(
                child: TextField(
                  controller: ctrl,
                  readOnly: readOnly,
                  style: TextStyle(
                      color: readOnly ? Colors.white54 : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (!isPrefix && extra != null) extra,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotifications() {
    return _cardWrapper(
      icon: Icons.notifications_none,
      title: 'NOTIFICATION PREFERENCES',
      child: Column(
        children: [
          _toggleRow(
              'Broadcast Announcements',
              'Stay updated with official news and updates',
              _t1,
              () => setState(() => _t1 = !_t1)),
          _toggleRow(
              'Support Replies',
              'Get notified when support staff replies to your tickets',
              _t2,
              () => setState(() => _t2 = !_t2)),
          _toggleRow(
              'Signal Alerts',
              'Receive real-time trading signals and alerts',
              _t3,
              () => setState(() => _t3 = !_t3)),
          _toggleRow(
              'Payment Updates',
              'Notifications about your subscriptions and payments',
              _t4,
              () => setState(() => _t4 = !_t4)),
          _toggleRow(
              'In-App Push Notifications',
              'Receive real-time alerts inside the app',
              _t5,
              () => setState(() => _t5 = !_t5),
              isLast: true),
        ],
      ),
    );
  }

  Widget _toggleRow(
      String title, String subtitle, bool isActive, VoidCallback onTap,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onTap,
                child: Container(
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? gold : const Color(0xFF222222),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(2),
                  alignment:
                      isActive ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 20),
            Container(height: 1, color: border),
          ]
        ],
      ),
    );
  }

  Widget _buildBilling() {
    return _cardWrapper(
      icon: Icons.credit_card,
      title: 'BILLING',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _billingBox('CURRENCY', '—')),
              const SizedBox(width: 8),
              Expanded(child: _billingBox('CURRENT PLAN', '—')),
              const SizedBox(width: 8),
              Expanded(child: _billingBox('NEXT BILLING', '—')),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: gold.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('View Billing History',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _billingBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0704),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return _cardWrapper(
      icon: Icons.language,
      title: 'PREFERENCES',
      child: Row(
        children: [
          Expanded(child: _dropdownBase('Language', 'English')),
          const SizedBox(width: 8),
          Expanded(child: _dropdownBase('Time Zone', '')),
          const SizedBox(width: 8),
          Expanded(child: _dropdownBase('Theme Mode', 'Dark')),
        ],
      ),
    );
  }

  Widget _dropdownBase(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0C0704),
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white38, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegal() {
    return _cardWrapper(
      icon: Icons.description_outlined,
      title: 'LEGAL',
      child: Column(
        children: [
          _legalRow('Terms & Conditions'),
          _legalRow('Privacy Policy'),
          _legalRow('Refund Policy', isLast: true),
        ],
      ),
    );
  }

  Widget _legalRow(String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF090501),
        border: Border.all(color: const Color(0xFFFF0033).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danger Zone',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                  child: _dangerBtn('Logout', false, icon: Icons.logout),
                ),
              ),
              _dangerBtn('Cancel Subscription', false),
              _dangerBtn('Delete Account', true, icon: Icons.delete_outline),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
              'Warning: Deleting your account is permanent and cannot be undone.',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _dangerBtn(String label, bool isSolid, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSolid ? const Color(0xFFFF0033) : Colors.transparent,
        border: Border.all(color: const Color(0xFFFF0033)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                color: isSolid ? Colors.white : const Color(0xFFFF0033),
                size: 16),
            const SizedBox(width: 8),
          ],
          Text(label,
              style: TextStyle(
                  color: isSolid ? Colors.white : const Color(0xFFFF0033),
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class VerticalAccentLine extends StatelessWidget {
  const VerticalAccentLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: const Color(0xFF3A2500),
    );
  }
}
