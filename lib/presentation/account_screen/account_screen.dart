import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import '../../widgets/shared/glass_container.dart';
import '../../widgets/shared/neon_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
        title: Text('Account',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          _buildProfileSection(context),
          SizedBox(height: 3.h),
          _buildSubscriptionSection(context),
          SizedBox(height: 3.h),
          _buildBillingSection(context),
          SizedBox(height: 3.h),
          _buildSecuritySection(context),
          SizedBox(height: 3.h),
          _buildDangerZone(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return GlassContainer(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 8.w,
                backgroundColor: Color(0xFF5A67F8),
                child: Text('J',
                    style: GoogleFonts.inter(
                        fontSize: 24.sp, color: Colors.white)),
              ),
              SizedBox(width: 4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jules Verne',
                      style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text('jules.verne@example.com',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white.withAlpha((255 * 0.7).round()))),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Divider(color: Colors.white.withAlpha((255 * 0.2).round())),
          SizedBox(height: 1.h),
          _buildAccountAction(
              context, 'Edit Name', () {}),
          _buildAccountAction(
              context, 'Change Email', () {}),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscription',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 2.h),
          GlassContainer(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow.shade700, size: 8.w),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pro Plan',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text('Renews on 2025-09-30',
                        style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.white.withAlpha((255 * 0.7).round()))),
                  ],
                ),
              ],
            ),
          ),
           SizedBox(height: 2.h),
          _buildUsageMeter('Storage', 45, 100, 'GB'),
           SizedBox(height: 1.h),
          _buildUsageMeter('Render Minutes', 12, 60, 'min'),
           SizedBox(height: 2.h),
          _buildAccountAction(context, 'Manage Subscription', () {
            Navigator.pushNamed(context, AppRoutes.pricing);
          }),
        ],
      ),
    );
  }

  Widget _buildUsageMeter(String label, double value, double total, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(color: Colors.white70)),
            Text('$value / $total $unit', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: value / total,
          backgroundColor: Colors.white.withAlpha((255 * 0.2).round()),
          color: const Color(0xFF5A67F8),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildBillingSection(BuildContext context) {
    return GlassContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Billing',
            style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 1.h),
        _buildAccountAction(context, 'Update Payment Method', () {}),
        _buildAccountAction(context, 'View Invoices', () {
          Navigator.pushNamed(context, AppRoutes.invoices);
        }),
      ],
    ));
  }

  Widget _buildSecuritySection(BuildContext context) {
    return GlassContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Security',
            style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 1.h),
        _buildAccountAction(context, 'Change Password', () {}),
      ],
    ));
  }

  Widget _buildDangerZone(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Danger Zone',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400)),
          SizedBox(height: 2.h),
          NeonButton(
            text: 'Log Out',
            onPressed: () => _showLogoutDialog(context),
            isPrimary: false, // Custom style will be applied
          ),
        ],
      ),
    );
  }

  Widget _buildAccountAction(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: GoogleFonts.inter(color: Colors.white)),
      trailing: Icon(Icons.arrow_forward_ios,
          color: Colors.white.withAlpha((255 * 0.5).round()), size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return GlassContainer(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 35.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Log Out?', style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 2.h),
              Text('Are you sure you want to log out?', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white70)),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      isPrimary: false,
                      height: 45,
                    ),
                  ),
                  SizedBox(width: 2.w),
                   Expanded(
                    child: NeonButton(
                      text: 'Log Out',
                      height: 45,
                      onPressed: () {
                        print("Logging out...");
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
