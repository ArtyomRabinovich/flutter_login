import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/background_shape.dart';
import '../../widgets/shared/glass_container.dart';
import '../../routes/app_routes.dart';
import '../../widgets/shared/neon_button.dart';
import '../../widgets/custom_icon_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _shapesAnimationController;
  late Animation<double> _shapesAnimation;
  late AnimationController _contentAnimationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _contentAnimationController.forward();
  }

  void _setupAnimations() {
    // Background shapes animation
    _shapesAnimationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat(reverse: true);

    _shapesAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _shapesAnimationController, curve: Curves.easeInOut));

    // Content entrance animation
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _contentAnimationController,
            curve: Interval(0.2, 1.0, curve: Curves.easeOut)));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _contentAnimationController,
                curve: Interval(0.2, 1.0, curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    _shapesAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, AppRoutes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _shapesAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 10.h,
                    left: 80.w * _shapesAnimation.value,
                    child: const BackgroundShape(
                        color: Color(0xFF5A67F8), size: 200),
                  ),
                  Positioned(
                    bottom: 15.h,
                    right: 70.w * _shapesAnimation.value - 40.w,
                    child: const BackgroundShape(
                        color: Color(0xFFC73EF1), size: 250),
                  ),
                ],
              );
            },
          ),

          // UI Content
          FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      // Branding Section
                      GlassContainer(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 6.h),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'lock_open',
                              color: Colors.white,
                              size: 15.w,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Flutter Login',
                              style: GoogleFonts.inter(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Your project starts here.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 2),
                      // Action Buttons
                      NeonButton(
                        text: 'Get Started',
                        onPressed: _navigateToSignUp,
                        isPrimary: true,
                      ),
                      SizedBox(height: 2.h),
                      NeonButton(
                        text: 'Log In',
                        onPressed: _navigateToLogin,
                        isPrimary: false,
                      ),
                      const Spacer(flex: 1),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement Learn More
                        },
                        child: Text(
                          'Learn more',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
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
