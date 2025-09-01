import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/background_shape.dart';
import '../../widgets/shared/glass_container.dart';

class LearnMoreScreen extends StatelessWidget {
  const LearnMoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      appBar: AppBar(
        title: const Text('Learn More'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 10,
            left: 10,
            child: BackgroundShape(color: Color(0xFF5A67F8), size: 200),
          ),
          const Positioned(
            bottom: 10,
            right: 10,
            child: BackgroundShape(color: Color(0xFFC73EF1), size: 250),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: GlassContainer(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'A mobile video editor you talk to.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'You upload clips, tell it what you want, it assembles the edit. You preview, accept/modify/reject, and export. Manual tweaks are there if you want them.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.white.withAlpha((255 * 0.8).round()),
                        ),
                      ),
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
}