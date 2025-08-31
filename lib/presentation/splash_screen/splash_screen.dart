import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _shapesAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shapesAnimation;

  bool _isInitialized = false;
  String _loadingText = "Initializing...";

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller for transition
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Shapes animation controller for floating backgrounds
    _shapesAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Fade out animation
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Shapes animation
    _shapesAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shapesAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate checking stored authentication tokens
      setState(() {
        _loadingText = "Checking authentication...";
      });
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate loading user preferences
      setState(() {
        _loadingText = "Loading preferences...";
      });
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulate verifying biometric availability
      setState(() {
        _loadingText = "Preparing security...";
      });
      await Future.delayed(const Duration(milliseconds: 700));

      // Simulate preparing secure storage
      setState(() {
        _loadingText = "Finalizing setup...";
      });
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
        _loadingText = "Ready!";
      });

      // Wait a moment then navigate
      await Future.delayed(const Duration(milliseconds: 400));
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors
      setState(() {
        _loadingText = "Initialization failed. Retrying...";
      });
      await Future.delayed(const Duration(seconds: 2));
      _initializeApp(); // Retry
    }
  }

  void _navigateToNextScreen() async {
    // Start fade out animation
    await _fadeAnimationController.forward();

    if (mounted) {
      // Navigate to login screen (simulating no stored auth)
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    _shapesAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor:
          const Color(0xFF14141D), // Glass morphism dark background
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Stack(
              children: [
                // Animated background shapes
                AnimatedBuilder(
                  animation: _shapesAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width *
                              (_shapesAnimation.value * 0.2 - 0.2),
                          child: const _BackgroundShape(
                            color: Color(0xFF5A67F8), // Blue neon color
                            size: 200,
                          ),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.15,
                          right: MediaQuery.of(context).size.width *
                              (_shapesAnimation.value * 0.2 - 0.2),
                          child: const _BackgroundShape(
                            color: Color(0xFFC73EF1), // Purple neon color
                            size: 250,
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.4,
                          right: MediaQuery.of(context).size.width *
                              (_shapesAnimation.value * 0.15 - 0.1),
                          child: const _BackgroundShape(
                            color: Color(0xFF5A67F8), // Blue neon color
                            size: 150,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Main content with glass effect
                SafeArea(
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    child: Column(
                      children: [
                        // Top spacer
                        SizedBox(height: 15.h),

                        // Logo section with glass container
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _logoAnimationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _logoScaleAnimation.value,
                                  child: Opacity(
                                    opacity: _logoOpacityAnimation.value,
                                    child: _buildGlassContainer(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // App logo with neon glow
                                          Container(
                                            width: 25.w,
                                            height: 25.w,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withAlpha(
                                                  (255 * 0.3).round()),
                                              borderRadius:
                                                  BorderRadius.circular(6.w),
                                              border: Border.all(
                                                color: const Color(0xFF5A67F8)
                                                    .withAlpha(
                                                        (255 * 0.5).round()),
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF5A67F8)
                                                      .withAlpha(
                                                          (255 * 0.3).round()),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: CustomIconWidget(
                                                iconName: 'lock',
                                                color: Colors.white,
                                                size: 12.w,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 4.h),

                                          // App name with neon text effect
                                          Text(
                                            'Flutter Login',
                                            style: GoogleFonts.inter(
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1.2,
                                              shadows: [
                                                Shadow(
                                                  color: const Color(0xFF5A67F8)
                                                      .withAlpha(
                                                          (255 * 0.5).round()),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 1.h),

                                          // App tagline
                                          Text(
                                            'Secure Authentication',
                                            style: GoogleFonts.inter(
                                              fontSize: 16.sp,
                                              color: Colors.white.withAlpha(
                                                  (255 * 0.8).round()),
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Loading section with glass container
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Loading indicator with neon effect
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black
                                      .withAlpha((255 * 0.2).round()),
                                  border: Border.all(
                                    color: Colors.white
                                        .withAlpha((255 * 0.1).round()),
                                    width: 1,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 8.w,
                                  height: 8.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xFF5A67F8),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 3.h),

                              // Loading text
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _loadingText,
                                  key: ValueKey(_loadingText),
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.white
                                        .withAlpha((255 * 0.8).round()),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom section
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Column(
                            children: [
                              // Version info
                              Text(
                                'Version 1.0.0',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  color: Colors.white
                                      .withAlpha((255 * 0.6).round()),
                                ),
                              ),

                              SizedBox(height: 1.h),

                              // Copyright
                              Text(
                                '© 2024 Flutter Login App',
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  color: Colors.white
                                      .withAlpha((255 * 0.5).round()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5A67F8).withAlpha((255 * 0.15).round()),
            Colors.transparent,
            Colors.transparent,
            const Color(0xFFC73EF1).withAlpha((255 * 0.15).round()),
          ],
          stops: const [0.0, 0.4, 0.6, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23.5),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((255 * 0.25).round()),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// Background shape widget with glass blur effect
class _BackgroundShape extends StatelessWidget {
  final Color color;
  final double size;

  const _BackgroundShape({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.8).round()),
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}