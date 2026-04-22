import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../services/supabase_auth_service.dart';
import '../services/intelligence_service.dart';
import '../services/theme_service.dart';
import '../widgets/shared.dart';
import '../services/community_service.dart';
import 'package:intl/intl.dart';


class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  final _sbUser = sb.Supabase.instance.client.auth.currentUser;
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  bool _t1 = true;
  bool _t2 = true;
  bool _t3 = true;
  bool _t4 = true;
  bool _t5 = false;
  String _selectedMenu = 'PROFILE';
  bool _isNavExpanded = false; // Collapsibility state
  bool _isSidebarOpen = false; // Mobile sidebar state

  @override
  void initState() {
    super.initState();
    final name = _sbUser?.email ?? 'New Trader';
    final email = _sbUser?.email ?? 'unknown@example.com';
    
    _nameCtrl = TextEditingController(text: name);
    _emailCtrl = TextEditingController(text: email);
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
    // Supabase handles profile updates differently (via the 'users' table or auth.updateUser)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile update logic needs Supabase table setup.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 850;

        // Global Announcement Listener (triggers regardless of current tab)
        ref.listen(communityMessagesProvider, (previous, next) {
          if (next.hasValue && previous != null && previous.hasValue) {
            final nextMsgs = next.value!;
            final prevMsgs = previous.value!;
            if (nextMsgs.isNotEmpty && (prevMsgs.isEmpty || nextMsgs.first.id != prevMsgs.first.id)) {
              _showNewMessagePopup(nextMsgs.first);
            }
          }
        });

        if (isWide) {

          return Row(
            children: [
              _buildAccountNavigationSidebar(),
              const VerticalDivider(width: 1, thickness: 1, color: border),
              Expanded(
                child: _buildMainScrollableContent(isWide),
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              Column(
                children: [
                  _buildAccountNavigationHorizontal(),
                  Expanded(
                    child: _buildMainScrollableContent(isWide),
                  ),
                ],
              ),
              if (_isSidebarOpen)
                GestureDetector(
                  onTap: () => setState(() => _isSidebarOpen = false),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              _buildSidebar(constraints.maxWidth),
            ],
          );
        }
      },
    );
  }

  Widget _buildMainScrollableContent(bool isWide) {
    return ListView(
      padding: isWide
          ? const EdgeInsets.all(24)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        if (_selectedMenu == 'PROFILE') ...[
          _buildHeader(),
          const SizedBox(height: 20),
          _buildPersonalInfo(),
          const SizedBox(height: 20),
          _buildPreferences(),
          const SizedBox(height: 20),
          _buildDangerZone(),
        ] else if (_selectedMenu == 'ALERTS') ...[
          _buildHeader(
              customTitle: 'NOTIFICATIONS',
              customSubtitle: 'Manage how and when you receive alerts'),
          const SizedBox(height: 20),
          _buildNotifications(),
        ] else if (_selectedMenu == 'PLAN' ||
            _selectedMenu == 'HISTORY' ||
            _selectedMenu == 'VERIFY') ...[
          _buildHeader(
              customTitle: 'BILLING & PAYMENTS',
              customSubtitle: 'Manage your active plans and records'),
          const SizedBox(height: 20),
          _buildBilling(),
        ] else if (_selectedMenu == 'COMMUNITY') ...[
          _buildCommunityHeader(),
          const SizedBox(height: 24),
          _buildCommunityTabs(),
          const SizedBox(height: 24),
          _buildCommunityContent(),
        ] else if (_selectedMenu == 'HELP') ...[
          _buildLegal(),

          const SizedBox(height: 20),
          _placeholderPanel(
              'SUPPORT TICKETS', 'You have 0 active support tickets.'),
        ],
        const SizedBox(height: 100), // Space for bottom navigation
      ],
    );
  }

  Widget _placeholderPanel(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeSection(context),
        border: Border.all(color: themeBorder(context)),
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
                style: TextStyle(
                  color: themeText(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(subtitle,
              style: TextStyle(
                  color: themeTextDim(context), fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildAccountNavigationSidebar() {
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
                _accountNavItem(Icons.people_outline, 'COMMUNITY', 'COMMUNITY'),
                _accountNavItem(Icons.shield_outlined, 'PLAN', 'PLAN'),
                _accountNavItem(Icons.receipt_long, 'HISTORY', 'HISTORY'),
                _accountNavItem(Icons.credit_card, 'VERIFY', 'VERIFY'),
                _accountNavItem(Icons.settings_outlined, 'PROFILE', 'PROFILE'),
                _accountNavItem(Icons.notifications_none, 'ALERTS', 'NOTIF'),
                _accountNavItem(Icons.help_outline, 'HELP', 'SUPPORT'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountNavigationHorizontal() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: themeSurface(context),
        border: Border(bottom: BorderSide(color: themeBorder(context).withOpacity(0.5))),
      ),
      child: Row(
        children: [
          // Radar Trigger Icon with Ripple Effect
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
                      _isNavExpanded ? Icons.close : Icons.account_circle_outlined, 
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
                      _accountNavItem(Icons.people_outline, 'COMMUNITY', 'COMMUNITY'),
                      _accountNavItem(Icons.shield_outlined, 'PLAN', 'PLAN'),
                      _accountNavItem(Icons.receipt_long, 'HISTORY', 'HISTORY'),
                      _accountNavItem(Icons.credit_card, 'VERIFY', 'VERIFY'),
                      _accountNavItem(Icons.settings_outlined, 'PROFILE', 'PROFILE'),
                      _accountNavItem(Icons.notifications_none, 'ALERTS', 'NOTIF'),
                      _accountNavItem(Icons.help_outline, 'HELP', 'SUPPORT'),
                      const SizedBox(width: 8),
                      // Logout in horizontal menu
                      _accountNavItem(Icons.logout, 'LOGOUT', 'LOGOUT', activeColor: const Color(0xFFFF0033)),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(double screenWidth) {
    final double sidebarWidth = screenWidth * 0.85; // Slightly wider for subtitles
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: _isSidebarOpen ? 0 : -sidebarWidth,
      top: 0,
      bottom: 0,
      child: Container(
        width: sidebarWidth,
        decoration: BoxDecoration(
          color: themeSurface(context),
          border: Border(right: BorderSide(color: gold.withOpacity(0.1))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 40,
              spreadRadius: 10,
            )
          ],
        ),
        child: Column(
          children: [
            // Sidebar Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
              child: Row(
                children: [
                  const Icon(Icons.account_circle_outlined, color: gold, size: 20),
                  const SizedBox(width: 12),
                  const Text(
                    'ACCOUNT SYSTEM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(margin: const EdgeInsets.symmetric(horizontal: 24), height: 1, color: Colors.white.withOpacity(0.05)),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _sidebarSectionLabel('NETWORK'),
                    _buildSidebarItem(Icons.people_outline, 'COMMUNITY', 'Announcements & Forums'),
                    
                    const SizedBox(height: 20),
                    _sidebarSectionLabel('BILLING'),
                    _buildSidebarItem(Icons.shield_outlined, 'PLAN', 'Manage Your Plan', shortNameOverride: 'SUBSCRIPTION'),
                    _buildSidebarItem(Icons.receipt_long, 'HISTORY', 'Invoices & Records', shortNameOverride: 'PAYMENT HISTORY'),
                    _buildSidebarItem(Icons.credit_card, 'VERIFY', 'Submit Crypto TXID', shortNameOverride: 'VERIFY PAYMENT'),
                    
                    const SizedBox(height: 20),
                    _sidebarSectionLabel('PREFERENCES'),
                    _buildSidebarItem(Icons.settings_outlined, 'PROFILE', 'Security & Details', shortNameOverride: 'PROFILE SETTINGS'),
                    _buildSidebarItem(Icons.notifications_none, 'ALERTS', 'Alert Preferences', shortNameOverride: 'NOTIFICATIONS'),
                    _buildSidebarItem(Icons.help_outline, 'HELP', 'Help Tickets', shortNameOverride: 'SUPPORT'),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildSidebarLogout(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sidebarSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Text(
        label,
        style: TextStyle(
          color: themeTextDim(context).withOpacity(0.5),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String moduleId, String subtitle, {String? shortNameOverride}) {
    final bool isSelected = _selectedMenu == moduleId;
    final String title = shortNameOverride ?? moduleId;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedMenu = moduleId;
          _isSidebarOpen = false;
        }),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? gold.withOpacity(0.05) : Colors.transparent,
            border: Border.all(
              color: isSelected ? gold.withOpacity(0.5) : Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? gold : themeText(context).withOpacity(0.5),
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? gold : Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isSelected ? gold.withOpacity(0.6) : themeTextDim(context).withOpacity(0.3),
                        fontSize: 9,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarLogout() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await SupabaseAuthService.signOut();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0033).withOpacity(0.1),
                  border: Border.all(color: const Color(0xFFFF0033).withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.logout, color: Color(0xFFFF0033), size: 16),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'LOGOUT',
                style: TextStyle(
                  color: Color(0xFFFF0033),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountNavItem(IconData icon, String title, String shortName, {Color activeColor = gold}) {
    final bool isSelected = _selectedMenu == title;
    final bool isLogout = title == 'LOGOUT';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (isLogout) {
            await SupabaseAuthService.signOut();
          } else {
            setState(() {
              _selectedMenu = title;
              _isNavExpanded = false; // Collapse on choice
            });
          }
        },
        child: Container(
          width: 80,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected || isLogout
                      ? activeColor.withOpacity(0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected || isLogout
                        ? activeColor.withOpacity(0.6)
                        : Colors.white.withOpacity(0.02),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: (isSelected || isLogout) ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ] : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected || isLogout 
                        ? activeColor 
                        : themeText(context).withOpacity(0.40),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (isSelected || isLogout || _isNavExpanded) ? 1.0 : 0.0,
                  child: Text(
                    shortName,
                    style: TextStyle(
                      color: isSelected || isLogout ? activeColor : themeTextDim(context).withOpacity(0.35),
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

  Widget _buildHeader(
      {String customTitle = 'PROFILE & SETTINGS',
      String customSubtitle = 'Manage your account preferences'}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: themeSection(context).withOpacity(0.5),
            border: Border.all(color: gold.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person_outline, color: gold, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customTitle,
                  style: TextStyle(
                      color: themeText(context),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0)),
              const SizedBox(height: 4),
              Text(customSubtitle,
                  style: TextStyle(
                      color: themeTextDim(context).withOpacity(0.6),
                      fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardWrapper(
      {required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeSection(context),
        border: Border.all(color: themeBorder(context)),
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
                style: TextStyle(
                  color: themeText(context),
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
                child: Text('SAVE CHANGES',
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

  Widget _buildCommunityHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeSection(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: gold.withOpacity(0.1)),
              ),
              child: const Icon(Icons.people_alt_outlined, color: gold, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COMMUNITY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Connect and learn from the trading community',
                  style: TextStyle(
                    color: themeTextDim(context).withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommunityTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: themeSection(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeBorder(context).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          _communityTabItem('Announcements', Icons.campaign_outlined, true),
          _communityTabItem('Live Chat', Icons.chat_bubble_outline, false),
          _communityTabItem('Community Forum', Icons.forum_outlined, false),
        ],
      ),
    );
  }

  Widget _communityTabItem(String label, IconData icon, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? gold.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? Border.all(color: gold.withOpacity(0.3)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? gold : themeTextDim(context), size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? gold : themeTextDim(context),
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityContent() {
    final messagesAsync = ref.watch(communityMessagesProvider);

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign_outlined, color: gold, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Important Updates',
                  style: TextStyle(
                    color: themeText(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: themeSection(context),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: themeTextDim(context).withOpacity(0.2)),
              ),
              child: Text(
                '1 ANNOUNCEMENTS',
                style: TextStyle(
                   color: themeTextDim(context).withOpacity(0.5),
                   fontSize: 10,
                   fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        messagesAsync.when(
          data: (messages) {
            if (messages.isEmpty) {
              return _placeholderPanel('NO UPDATES', 'Check back later for community announcements.');
            }
            return Column(
              children: messages.map((m) => _buildMessageCard(m)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: gold)),
          error: (err, _) => Center(child: Text('Error: $err', style: TextStyle(color: themeTextDim(context)))),
        ),
      ],
    );
  }

  Widget _buildMessageCard(CommunityMessage message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeSection(context),
        border: Border.all(color: themeBorder(context)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.05),
                  border: Border.all(color: gold.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  message.type.toUpperCase(),
                  style: const TextStyle(color: gold, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                DateFormat('M/d/yyyy, h:mm:ss a').format(message.createdAt),
                style: TextStyle(color: themeTextDim(context).withOpacity(0.3), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message.title,
            style: TextStyle(
              color: themeText(context),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message.content,
            style: TextStyle(
              color: themeTextDim(context).withOpacity(0.8),
              fontSize: 13,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '— Team D Trade Capital',
            style: TextStyle(
              color: themeTextDim(context).withOpacity(0.5),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewMessagePopup(CommunityMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0C0704),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: gold.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: gold.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
              )
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: gold,
                radius: 12,
                child: Icon(Icons.notifications_active, color: Colors.black, size: 14),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NEW ANNOUNCEMENT',
                      style: TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      message.title,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedMenu = 'COMMUNITY'),
                child: const Text('VIEW', style: TextStyle(color: gold, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, Widget? extra,

      {bool isPrefix = false, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: themeTextDim(context),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: themeSection(context),
            border: Border.all(color: themeBorder(context)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (isPrefix && extra != null) ...[
                extra,
                const SizedBox(width: 8),
                Icon(Icons.arrow_drop_down,
                    color: themeTextDim(context).withOpacity(0.7), size: 16),
                const SizedBox(width: 8)
              ],
              Expanded(
                child: TextField(
                  controller: ctrl,
                  readOnly: readOnly,
                  style: TextStyle(
                      color: readOnly ? themeTextDim(context) : themeText(context),
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
    final user = sb.Supabase.instance.client.auth.currentUser;
    final alertsAsync = user != null ? ref.watch(userAlertsProvider(user.id)) : const AsyncValue.data([]);

    return Column(
      children: [
        _cardWrapper(
          icon: Icons.notifications_active_outlined,
          title: 'RECENT ALERTS',
          child: alertsAsync.when(
            data: (alerts) {
              if (alerts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text('No active alerts', style: TextStyle(color: themeTextDim(context).withOpacity(0.5))),
                  ),
                );
              }
              return Column(
                children: alerts.map((a) => _alertItem(a)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: gold)),
            error: (err, _) => Center(child: Text('Error loading alerts', style: TextStyle(color: themeTextDim(context)))),
          ),
        ),
        const SizedBox(height: 24),
        _cardWrapper(
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
        ),
      ],
    );
  }

  Widget _alertItem(dynamic alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.05),
        border: Border.all(color: gold.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(alert['type']?.toString().toUpperCase() ?? 'INFO',
                  style: const TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(alert['time'] ?? 'Just now', style: TextStyle(color: themeTextDim(context), fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Text(alert['message'] ?? 'No message content',
              style: TextStyle(color: themeText(context), fontSize: 13, height: 1.4)),
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
                        style: TextStyle(
                            color: themeText(context),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            color: themeTextDim(context), fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    alignment:
                        isActive ? Alignment.centerRight : Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: isActive ? gold : themeBorder(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
            child: Text('View Billing History',
                style: TextStyle(
                    color: themeText(context),
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
        color: themeSection(context),
        border: Border.all(color: themeBorder(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: themeTextDim(context),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  color: themeText(context),
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
          Expanded(
            child: ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeService.themeModeNotifier,
                builder: (context, mode, _) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        ThemeService.setTheme(mode == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark);
                      },
                      child: _dropdownBase('Theme Mode',
                          mode == ThemeMode.dark ? 'Dark' : 'Light'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _dropdownBase(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: themeTextDim(context), fontSize: 11)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: themeSection(context),
            border: Border.all(color: themeBorder(context)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value,
                  style: TextStyle(
                      color: themeText(context),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Icon(Icons.keyboard_arrow_down,
                  color: themeTextDim(context).withOpacity(0.7), size: 16),
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
              style: TextStyle(
                  color: themeText(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_forward_ios,
              color: themeTextDim(context).withOpacity(0.7), size: 14),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeSurface(context),
        border: Border.all(color: const Color(0xFFFF0033).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: TextStyle(
              color: themeText(context),
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
                  onTap: () async {
                    await SupabaseAuthService.signOut();
                  },
                  child: _dangerBtn('Logout', false, icon: Icons.logout),
                ),
              ),
              _dangerBtn('Cancel Subscription', false),
              _dangerBtn('Delete Account', true, icon: Icons.delete_outline),
            ],
          ),
          const SizedBox(height: 16),
          Text(
              'Warning: Deleting your account is permanent and cannot be undone.',
              style: TextStyle(color: themeTextDim(context), fontSize: 12)),
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
