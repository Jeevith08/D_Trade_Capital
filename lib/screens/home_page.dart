import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/shared.dart';
import 'trading_view.dart';
import 'intelligence_view.dart';
import 'account_view.dart';

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
