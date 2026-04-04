import 'package:flutter/material.dart';
import '../widgets/shared.dart';

class IntelligenceView extends StatefulWidget {
  const IntelligenceView({super.key});

  @override
  State<IntelligenceView> createState() => _IntelligenceViewState();
}

class _IntelligenceViewState extends State<IntelligenceView> with SingleTickerProviderStateMixin {
  String _selectedModule = 'GEOINTEL';
  bool _isNavExpanded = false; // Collapsible nav state
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildGeoIntelContent(bool isWide) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Active Hotspots
          Expanded(
            flex: 4,
            child: _buildActiveHotspots(),
          ),
          const SizedBox(width: 24),
          // Right: Map and AI Intelligence
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _buildMapArea(),
                const SizedBox(height: 24),
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
          const SizedBox(height: 24),
          _buildTopStatsMobile(),
          const SizedBox(height: 24),
          _buildActiveHotspots(),
          const SizedBox(height: 24),
          _buildAIGeneratedSignals(),
        ],
      );
    }
  }

  Widget _buildModuleContent(bool isWide) {
    switch (_selectedModule) {
      case 'GEOINTEL':
        return _buildGeoIntelContent(isWide);
      case 'PATTERN INSIGHTS':
        return _buildPatternInsightsContent();
      case 'TRADER GENOME':
        return _buildTraderGenomeContent();
      case 'COGNITIVE FITNESS':
        return _buildCognitiveFitnessContent();
      default:
        return _buildGeoIntelContent(isWide);
    }
  }

  bool _isRefreshing = false;

  void _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  Widget _buildPatternInsightsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart, color: gold, size: 24),
                    const SizedBox(width: 12),
                    Text('PATTERN INSIGHTS',
                        style: TextStyle(
                            color: themeText(context),
                            fontSize: 15,
                            fontFamily: 'AgencyFB',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Behavioural detection engine — waiting for first trades',
                    style: TextStyle(
                        color: themeTextDim(context).withOpacity(0.5),
                        fontSize: 13)),
              ],
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _isRefreshing ? null : _handleRefresh,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      color: themeSurface(context),
                      border: Border.all(color: themeBorder(context)),
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isRefreshing
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                  color: gold, strokeWidth: 2))
                          : Icon(Icons.refresh,
                              color: themeText(context).withOpacity(0.8), size: 14),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _isRefreshing ? 'REFRESHING...' : 'REFRESH',
                            style: TextStyle(
                              color: themeText(context),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: themeSurface(context).withOpacity(0.5),
              border: Border.all(color: themeBorder(context)),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: gold.withOpacity(0.1),
                        border: Border.all(color: gold.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Row(
                      children: [
                        Icon(Icons.analytics, color: gold, size: 14),
                        SizedBox(width: 8),
                        Text('RULE BASED ANALYSIS',
                            style: TextStyle(
                                color: gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text('50 MORE TRADES TO UNLOCK STATISTICAL ANALYSIS',
                        style: TextStyle(
                            color: themeTextDim(context).withOpacity(0.4),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ),
                  Text('0 / 50',
                      style: TextStyle(
                          color: themeTextDim(context).withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(2)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.05,
                  child: Container(
                    decoration: BoxDecoration(
                        color: gold, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 80),
          decoration: BoxDecoration(
              color: themeSurface(context).withOpacity(0.3),
              border: Border.all(color: themeBorder(context)),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: gold.withOpacity(0.05),
                    border: Border.all(color: gold.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.analytics_outlined, color: gold, size: 48),
              ),
              const SizedBox(height: 24),
              const Text('BUILDING YOUR PROFILE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'AgencyFB',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
              const SizedBox(height: 16),
              SizedBox(
                width: 400,
                child: Text(
                  'Execute your first trades using the Trading Engine. Pattern detection activates automatically as your history grows.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeTextDim(context).withOpacity(0.5),
                      fontSize: 14,
                      height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _unlockCard('RULE-BASED PATTERNS', 'Unlocks at 1+ trades',
                        Icons.onetwothree_outlined, true),
                    const SizedBox(width: 16),
                    _unlockCard('STATISTICAL ANALYSIS', 'Unlocks at 50+ trades',
                        Icons.bar_chart_outlined, false),
                    const SizedBox(width: 16),
                    _unlockCard('PERSONAL AI MODEL', 'Unlocks at 200+ trades',
                        Icons.smart_toy_outlined, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _unlockCard(String title, String status, IconData icon, bool isActive) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: isActive ? gold.withOpacity(0.02) : Colors.transparent,
          border: Border.all(
              color: isActive ? gold.withOpacity(0.3) : themeBorder(context)),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: isActive ? gold : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6)),
            child: Icon(icon,
                color: isActive ? Colors.black : Colors.white24, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: TextStyle(
                  color: isActive ? Colors.white : Colors.white38,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(status,
              style: TextStyle(
                  color: isActive
                      ? gold.withOpacity(0.7)
                      : Colors.white.withOpacity(0.15),
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 850;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed Icon Sidebar
              Container(
                width: 85,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: themeSurface(context).withOpacity(0.5),
                  border: Border(right: BorderSide(color: themeBorder(context))),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: _buildIntelModulesFixed(),
                ),
              ),
              // Main Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildTopStats(),
                      const SizedBox(height: 24),
                      _buildModuleContent(true),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              // Horizontal Mini Navigation for Mobile
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: themeSurface(context),
                  border: Border(bottom: BorderSide(color: themeBorder(context))),
                ),
                child: Row(
                  children: [
                    // Radar Trigger Icon with Premium Ripple & Glow Effect
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _isNavExpanded = !_isNavExpanded),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isNavExpanded 
                                  ? gold.withOpacity(0.15) 
                                  : Colors.white.withOpacity(0.02),
                              border: Border.all(
                                color: _isNavExpanded 
                                    ? gold.withOpacity(0.5) 
                                    : Colors.white.withOpacity(0.05)
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _isNavExpanded ? [
                                BoxShadow(
                                  color: gold.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ] : [],
                            ),
                            child: Center(
                              child: Icon(
                                _isNavExpanded ? Icons.close : Icons.radar, 
                                color: gold, 
                                size: 20
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _isNavExpanded ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: !_isNavExpanded,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 8),
                                _intelModuleSidebarItem(Icons.public, 'GEOINTEL', 'GEOINTEL'),
                                _intelModuleSidebarItem(Icons.analytics_outlined, 'PATTERN INSIGHTS', 'PATTERN'),
                                _intelModuleSidebarItem(Icons.fingerprint, 'TRADER GENOME', 'GENOME'),
                                _intelModuleSidebarItem(Icons.psychology_outlined, 'COGNITIVE FITNESS', 'COGNITIVE'),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    _buildTopStats(),
                    const SizedBox(height: 24),
                    _buildModuleContent(false),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildIntelModulesFixed() {
    return GestureDetector(
      onTap: () => setState(() => _isNavExpanded = !_isNavExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 85,
        decoration: BoxDecoration(
          color: themeSurface(context),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ...[
                _intelModuleSidebarItem(Icons.public, 'GEOINTEL', 'GEOINTEL'),
                _intelModuleSidebarItem(Icons.analytics_outlined, 'PATTERN INSIGHTS', 'PATTERN'),
                _intelModuleSidebarItem(Icons.fingerprint, 'TRADER GENOME', 'GENOME'),
                _intelModuleSidebarItem(Icons.psychology_outlined, 'COGNITIVE FITNESS', 'COGNITIVE'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _intelModuleSidebarItem(IconData icon, String title, String shortName) {
    bool isSelected = _selectedModule == title;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedModule = title;
          _isNavExpanded = false; // Auto-collapse on selection
        }),
        child: Container(
          width: 70,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? gold.withOpacity(0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? gold.withOpacity(0.6)
                        : Colors.white.withOpacity(0.02),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: gold.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ] : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected 
                        ? gold 
                        : themeText(context).withOpacity(0.40), // More visible but still faint
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (isSelected || _isNavExpanded) ? 1.0 : 0.0,
                child: Text(
                  shortName,
                  style: TextStyle(
                    color: isSelected ? gold : themeTextDim(context).withOpacity(0.3),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            // Tension Index Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: themeBorder(context).withOpacity(0.5)),
                color: themeSurface(context).withOpacity(0.3),
              ),
              child: Row(
                children: [
                  Text('GLOBAL TENSION INDEX',
                      style: TextStyle(
                          color: themeTextDim(context).withOpacity(0.7),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                  const SizedBox(width: 16),
                  Text('71.4',
                      style: TextStyle(
                          color: gold,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Navigation Tabs
            Expanded(
              child: Container(
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
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Status Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: SingleChildScrollView(
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
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: themeBorder(context).withOpacity(0.3)),
      ],
    );
  }

  Widget _buildTopStatsMobile() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: themeBorder(context)),
            color: themeSection(context),
          ),
          child: Column(
            children: [
              Text('GLOBAL TENSION INDEX',
                  style: TextStyle(color: themeTextDim(context), fontSize: 9, letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text('71.4', style: TextStyle(color: gold, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _topTab('MAP', true),
            _topTab('NEWS', false),
            _topTab('CALENDAR', false),
            _topTab('SIGNALS', false),
            _topTab('MATRIX', false),
          ]),
        ),
      ],
    );
  }

  Widget _topTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? themeSection(context) : Colors.transparent,
        border: Border(
            bottom: BorderSide(
                color: isSelected ? gold : Colors.transparent, width: 1.5)),
      ),
      child: Text(label,
          style: TextStyle(
              color: isSelected ? gold : themeTextDim(context),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }

  Widget _statusBarItem(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: themeTextDim(context).withOpacity(0.7),
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
        color: themeSurface(context).withOpacity(0.3),
        border: Border.all(color: themeBorder(context).withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACTIVE HOTSPOTS',
                    style: TextStyle(
                        color: themeTextDim(context).withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF0033).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('9',
                      style: TextStyle(
                          color: Color(0xFFFF0033),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(height: 1, color: themeBorder(context).withOpacity(0.5)),
          _hotspotItem('WAR / GEO • IRAN', 'Hormuz Blockade', 88),
          _hotspotItem('WAR / GEO • UKRAINE', 'Drone Campaign', 82),
          _hotspotItem('WAR / GEO • RUSSIA', 'Sanctions Expand', 85),
          _hotspotItem('WAR / GEO • NORTH KOREA', 'Missile Launch', 79),
          _hotspotItem('WAR / GEO • ISRAEL', 'Regional Tension', 76),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _hotspotItem(String category, String title, int score) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeBorder(context)))),
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
              style: TextStyle(
                  color: themeText(context),
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('RISK SCORE:',
                  style: TextStyle(color: themeTextDim(context).withOpacity(0.7), fontSize: 10)),
              const SizedBox(width: 8),
              Text(score.toString(),
                  style: TextStyle(color: themeText(context).withOpacity(0.7), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: themeSurface(context),
        border: Border.all(color: themeBorder(context)),
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
        color: themeSurface(context).withOpacity(0.2),
        border: Border.all(color: themeBorder(context).withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, color: gold, size: 8),
                  const SizedBox(width: 8),
                  Text('AI INTELLIGENCE',
                      style: TextStyle(
                          color: gold.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.circle, color: Color(0xFF00FF66), size: 10),
                  const SizedBox(width: 8),
                  const Text('READY',
                      style: TextStyle(
                          color: Color(0xFF00FF66),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.03),
              border: const Border(left: BorderSide(color: gold, width: 3)),
            ),
            child: Text(
              'Institutional flow identifies dual-front escalation scenario. BRENT targeting \$90 range; favors XAU/USD. Max EUR divergence identified.',
              style: TextStyle(
                  color: themeText(context).withOpacity(0.8),
                  fontSize: 13,
                  height: 1.6,
                  fontFamily: 'monospace',
                  letterSpacing: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text('GENERATED SIGNALS',
              style: TextStyle(
                  color: themeTextDim(context).withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.05),
              border: Border.all(color: gold.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: gold, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Long-term AI directional bias — for educational purposes only. Not financial advice. Not for short-term trading.',
                    style: TextStyle(
                      color: gold.withOpacity(0.7), 
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraderGenomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Blowing Lock Icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      gold.withOpacity(0.15 * _pulseAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF131118),
                      border: Border.all(
                        color: gold.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gold.withOpacity(0.1),
                          blurRadius: 20 * _pulseAnimation.value,
                          spreadRadius: 5 * _pulseAnimation.value,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: gold,
                      size: 32,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          // Genome Locked Text
          const Text(
            'GENOME LOCKED',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'serif',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: themeTextDim(context).withOpacity(0.7),
                fontSize: 16,
                letterSpacing: 0.5,
              ),
              children: const [
                TextSpan(text: 'Need '),
                TextSpan(
                  text: '30 trades',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' to classify your archetype.'),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Progress Card
          Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0C1B1E).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PROGRESS',
                      style: TextStyle(
                        color: themeTextDim(context).withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      '0 / 30',
                      style: TextStyle(
                        color: Color(0xFF00FF66),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AgencyFB',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Custom Progress Bar
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: 0, // 0 progress for now
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: gold.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '30 more trades to unlock',
                    style: TextStyle(
                      color: themeTextDim(context).withOpacity(0.4),
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildCognitiveFitnessContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: themeSurface(context).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: themeBorder(context).withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing Trophy Icon
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00FF66).withOpacity(0.1 * _pulseAnimation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0C1B1E),
                        border: Border.all(
                          color: const Color(0xFF00FF66).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.emoji_events_outlined,
                        color: Color(0xFF33635A),
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            // Title
            const Text(
              'COGNITIVE STATUS: NO DATA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'serif',
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            // Subtitle
            SizedBox(
              width: 300,
              child: Text(
                'Start trading to see your Behavioral Fitness Score. Minimum 1 trade required.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeTextDim(context).withOpacity(0.5),
                  fontSize: 13,
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
