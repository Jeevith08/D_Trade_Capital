import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/shared.dart';

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
