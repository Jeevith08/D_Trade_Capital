import 'package:flutter/material.dart';
import '../widgets/shared.dart';

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
    final TextEditingController balanceController =
        TextEditingController(text: '100000');
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
