import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

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
        title: Text('Help & Support',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                _buildHelpItem(context, 'Help Center / FAQ', Icons.help_outline),
                _buildHelpItem(context, 'Contact Support', Icons.email_outlined),
                _buildHelpItem(context, 'Terms of Service', Icons.gavel_outlined),
                _buildHelpItem(context, 'Privacy Policy', Icons.shield_outlined),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, String title, IconData icon) {
    return GlassContainer(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: GoogleFonts.inter(color: Colors.white)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {
          // In a real app, this would open a webview or mailto link
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to $title...'))
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Text(
        'App Version 1.0.0', // This could be fetched dynamically
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(color: Colors.white.withAlpha((255 * 0.5).round()), fontSize: 10.sp),
      ),
    );
  }
}
