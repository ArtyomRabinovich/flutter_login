import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text('Settings',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          _buildMediaCacheSection(),
          SizedBox(height: 3.h),
          _buildPreferencesSection(),
          SizedBox(height: 3.h),
          _buildPrivacySection(),
           SizedBox(height: 3.h),
          _buildIntegrationsSection(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 1.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMediaCacheSection() {
    return _buildSection('Media & Cache', [
      _buildSettingRow(
        'Proxy Resolution',
        trailing: _buildDropdownMock('1080p'),
        onTap: () {},
      ),
      _buildSettingRow(
        'Clear Cache',
        subtitle: '2.4 GB',
        onTap: () {},
      ),
    ]);
  }

  Widget _buildPreferencesSection() {
     return _buildSection('Preferences', [
      _buildSettingRow(
        'Appearance',
        trailing: _buildDropdownMock('Dark'),
        onTap: () {},
      ),
       _buildSettingRow(
        'Language',
        trailing: _buildDropdownMock('English'),
        onTap: () {},
      ),
      _buildSettingRow(
        'Enable Notifications',
        trailing: Switch(value: true, onChanged: (val) {}, activeColor: Color(0xFF5A67F8)),
        onTap: null, // No action on row tap
      ),
    ]);
  }

  Widget _buildPrivacySection() {
    return _buildSection('Privacy', [
      _buildSettingRow(
        'Export My Data',
        onTap: () {},
      ),
       _buildSettingRow(
        'Delete My Account',
        onTap: () {},
      ),
      _buildSettingRow(
        'Allow Analytics',
        trailing: Switch(value: false, onChanged: (val) {}, activeColor: Color(0xFF5A67F8)),
        onTap: null,
      ),
    ]);
  }

  Widget _buildIntegrationsSection() {
     return _buildSection('Integrations', [
      _buildSettingRow(
        'Google Drive',
        trailing: Icon(Icons.link, color: Colors.green),
        onTap: () {},
      ),
       _buildSettingRow(
        'Stock Photos',
        trailing: Icon(Icons.link_off, color: Colors.white70),
        onTap: () {},
      ),
    ]);
  }

  Widget _buildSettingRow(String title, {String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title, style: GoogleFonts.inter(color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.inter(color: Colors.white70)) : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDropdownMock(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: GoogleFonts.inter(color: Colors.white70)),
        SizedBox(width: 1.w),
        Icon(Icons.unfold_more, color: Colors.white70),
      ],
    );
  }
}
