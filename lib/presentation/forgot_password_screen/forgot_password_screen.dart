import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isLoading = false;
  bool _emailSent = false;
  bool _canResend = true;
  int _resendCountdown = 0;
  String? _sentEmail;

  late AnimationController _shapesAnimationController;
  late Animation<double> _shapesAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize shapes animation
    _shapesAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _shapesAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shapesAnimationController,
      curve: Curves.easeInOut,
    ));

    // Auto-focus email field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    _shapesAnimationController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock different scenarios based on email
      final email = _emailController.text.toLowerCase();

      if (email == 'notfound@example.com') {
        _showErrorMessage(
            'No account found with this email address. Please check your email or create a new account.');
      } else if (email == 'ratelimit@example.com') {
        _showErrorMessage(
            'Too many reset attempts. Please wait 15 minutes before trying again.');
      } else if (email == 'network@example.com') {
        _showErrorMessage(
            'Network error. Please check your connection and try again.');
      } else {
        // Success case
        setState(() {
          _emailSent = true;
          _sentEmail = email;
        });

        _showSuccessMessage('Reset link sent to $email');

        // Auto-navigate back to login after 3 seconds
        _startAutoNavigation();
      }
    } catch (e) {
      _showErrorMessage('Something went wrong. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendEmail() async {
    if (!_canResend || _sentEmail == null) return;

    setState(() {
      _isLoading = true;
      _canResend = false;
      _resendCountdown = 60;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _showSuccessMessage('Reset link sent again to $_sentEmail');

      // Start countdown timer
      _startResendCountdown();
    } catch (e) {
      _showErrorMessage('Failed to resend email. Please try again.');
      setState(() {
        _canResend = true;
        _resendCountdown = 0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startResendCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });

        if (_resendCountdown <= 0) {
          setState(() {
            _canResend = true;
          });
          return false;
        }
      }
      return _resendCountdown > 0 && mounted;
    });
  }

  void _startAutoNavigation() {
    int countdown = 3;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown--;

      if (countdown <= 0 && mounted) {
        Navigator.pushReplacementNamed(context, '/login-screen');
        return false;
      }
      return countdown > 0 && mounted;
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5A67F8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF14141D), // Glass morphism dark background
      body: Stack(
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
                    top: MediaQuery.of(context).size.height * 0.6,
                    left: MediaQuery.of(context).size.width *
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
          // Main content
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        4.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 2.h),

                      // Back button with neon effect
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildNeonBackButton(),
                      ),

                      SizedBox(height: 4.h),

                      // Header Section in glass container
                      _buildGlassContainer(child: _buildHeaderSection()),

                      SizedBox(height: 4.h),

                      // Content Section in glass container
                      _buildGlassContainer(
                        child: _emailSent
                            ? _buildSuccessContent()
                            : _buildFormContent(),
                      ),

                      const Spacer(),

                      SizedBox(height: 2.h),
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

  Widget _buildNeonBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((255 * 0.3).round()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF5A67F8).withAlpha((255 * 0.5).round()),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5A67F8).withAlpha((255 * 0.3).round()),
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
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

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Icon with neon glow
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((255 * 0.3).round()),
            shape: BoxShape.circle,
            border: Border.all(
              color: (_emailSent
                      ? const Color(0xFF5A67F8)
                      : const Color(0xFFC73EF1))
                  .withAlpha((255 * 0.5).round()),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (_emailSent
                        ? const Color(0xFF5A67F8)
                        : const Color(0xFFC73EF1))
                    .withAlpha((255 * 0.3).round()),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _emailSent ? Icons.mark_email_read : Icons.lock_reset,
              color: Colors.white,
              size: 10.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Title with neon text effect
        Text(
          _emailSent ? 'Check Your Email' : 'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: const Color(0xFF5A67F8).withAlpha((255 * 0.5).round()),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 2.h),

        // Description
        Text(
          _emailSent
              ? 'We\'ve sent a password reset link to $_sentEmail'
              : 'Enter your email address and we\'ll send you a link to reset your password.',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Colors.white.withAlpha((255 * 0.8).round()),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Input Field
          _CustomTextField(
            controller: _emailController,
            focusNode: _focusNode,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !_isLoading,
            onFieldSubmitted: (_) => _sendResetLink(),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.white.withAlpha((255 * 0.5).round()),
            ),
          ),

          SizedBox(height: 4.h),

          // Send Reset Link Button - Neon Button
          _NeonButton(
            onPressed: _isLoading ? null : _sendResetLink,
            isLoading: _isLoading,
            text: 'Send Reset Link',
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        // Success Message with neon border
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((255 * 0.2).round()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF5A67F8).withAlpha((255 * 0.5).round()),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5A67F8).withAlpha((255 * 0.3).round()),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xFF5A67F8),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Email sent to $_sentEmail',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Resend Email Section
        Column(
          children: [
            Text(
              'Didn\'t receive the email?',
              style: GoogleFonts.inter(
                color: Colors.white.withAlpha((255 * 0.7).round()),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 1.h),
            TextButton(
              onPressed: _canResend && !_isLoading ? _resendEmail : null,
              child: _isLoading
                  ? SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF5A67F8),
                        ),
                      ),
                    )
                  : Text(
                      _canResend
                          ? 'Resend Email'
                          : 'Resend in ${_resendCountdown}s',
                      style: GoogleFonts.inter(
                        color: _canResend
                            ? const Color(0xFF5A67F8)
                            : Colors.white.withAlpha((255 * 0.5).round()),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Back to Login Button - Neon Button
        _NeonButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/login-screen'),
          text: 'Back to Login',
          isPrimary: false,
        ),
      ],
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

// Custom text field with dark glass morphism styling
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;

  const _CustomTextField({
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.onFieldSubmitted,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withAlpha((255 * 0.5).round()),
        ),
        filled: true,
        fillColor: Colors.black.withAlpha((255 * 0.2).round()),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * 0.1).round()),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF5A67F8).withAlpha((255 * 0.8).round()),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * 0.05).round()),
            width: 1.5,
          ),
        ),
        errorStyle: GoogleFonts.inter(color: Colors.red.shade300, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: prefixIcon,
              )
            : null,
      ),
    );
  }
}

// Neon button widget matching login screen style
class _NeonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final bool isPrimary;

  const _NeonButton({
    this.onPressed,
    this.isLoading = false,
    required this.text,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF5A67F8);
    const secondary = Color(0xFFC73EF1);
    const double height = 56;
    const double radius = 14;

    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer glow
            if (isPrimary)
              CustomPaint(
                painter: _NeonButtonPainter(
                  radius: radius,
                  primary: primary,
                  secondary: secondary,
                ),
                child: const SizedBox.expand(),
              ),

            // Button container
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((255 * 0.45).round()),
                    borderRadius: BorderRadius.circular(radius),
                    border: isPrimary
                        ? Border.all(
                            color: primary.withAlpha((255 * 0.5).round()),
                            width: 1,
                          )
                        : Border.all(
                            color: Colors.white.withAlpha((255 * 0.2).round()),
                            width: 1,
                          ),
                  ),
                ),
              ),
            ),

            // Button content
            isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Neon button painter for glow effect
class _NeonButtonPainter extends CustomPainter {
  final double radius;
  final Color primary;
  final Color secondary;

  _NeonButtonPainter({
    required this.radius,
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Outer glow
    final glowPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..shader = LinearGradient(
        colors: [
          primary.withAlpha((255 * 0.3).round()),
          secondary.withAlpha((255 * 0.3).round()),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..blendMode = BlendMode.plus;

    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
