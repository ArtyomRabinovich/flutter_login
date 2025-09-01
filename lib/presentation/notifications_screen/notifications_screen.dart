import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/glass_container.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime timestamp;
  final IconData icon;
  final Color iconColor;

  AppNotification({
    required this.title,
    required this.body,
    required this.timestamp,
    this.icon = Icons.notifications,
    this.iconColor = Colors.white,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  // Mock data
  final List<AppNotification> _notifications = const [
    // This list is empty to show the empty state by default.
    // In a real app, you would populate this from a service.
    // Example:
    // AppNotification(
    //   title: 'Render Complete',
    //   body: 'Your project "Vacation Highlights" has finished rendering.',
    //   timestamp: DateTime.now(),
    //   icon: Icons.check_circle,
    //   iconColor: Colors.green,
    // ),
  ];

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
        title: Text('Notifications',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: Text('Clear All', style: GoogleFonts.inter(color: Colors.white70)),
            )
        ],
      ),
      body: _notifications.isEmpty ? _buildEmptyState() : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 20.w, color: Colors.white.withAlpha((255 * 0.3).round())),
          SizedBox(height: 2.h),
          Text(
            'All Caught Up!',
            style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 1.h),
          Text(
            'You have no new notifications.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 14.sp, color: Colors.white.withAlpha((255 * 0.7).round())),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return GlassContainer(
          margin: EdgeInsets.only(bottom: 2.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification.iconColor.withAlpha((255 * 0.2).round()),
              child: Icon(notification.icon, color: notification.iconColor),
            ),
            title: Text(notification.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text(notification.body, style: GoogleFonts.inter(color: Colors.white70)),
            trailing: Text('5m ago', style: GoogleFonts.inter(color: Colors.white54, fontSize: 10.sp)),
          ),
        );
      },
    );
  }
}
