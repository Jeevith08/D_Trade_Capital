import 'package:flutter/material.dart';
import '../widgets/shared.dart';

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
