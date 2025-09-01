import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ======== GLASS MORPHISM LOGIN SCREEN ========
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Mock credentials for demonstration
  final String _mockEmail = "demo@flutter.com";
  final String _mockPassword = "Flutter123!";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_emailController.text.trim() == _mockEmail &&
        _passwordController.text == _mockPassword) {
      // Success haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login successful! Welcome back.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xff5A67F8),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to main app (splash screen for demo)
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/home-screen');
      }
    } else {
      // Error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid credentials. Please check your email and password.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password-screen');
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/signup-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff14141D),
      // Use a Stack to layer the animation behind the form
      body: Stack(
        children: [
          // Animated background shapes
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    left:
                        MediaQuery.of(context).size.width *
                        (_animation.value * 0.2 - 0.2),
                    child: const _BackgroundShape(
                      color: Color(0xff5A67F8),
                      size: 200,
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.15,
                    right:
                        MediaQuery.of(context).size.width *
                        (_animation.value * 0.2 - 0.2),
                    child: const _BackgroundShape(
                      color: Color(0xffC73EF1),
                      size: 250,
                    ),
                  ),
                ],
              );
            },
          ),
          // Centered login form
          Center(
            // Added SingleChildScrollView to prevent overflow
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: GlassLoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  isLoading: _isLoading,
                  mockEmail: _mockEmail,
                  mockPassword: _mockPassword,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                  onSignUp: _handleSignUp,
                  validateEmail: _validateEmail,
                  validatePassword: _validatePassword,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The widget for the blurred background shapes
class _BackgroundShape extends StatelessWidget {
  final Color color;
  final double size;

  const _BackgroundShape({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class GlassLoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final String mockEmail;
  final String mockPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;

  const GlassLoginForm({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.mockEmail,
    required this.mockPassword,
    required this.onTogglePasswordVisibility,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.validateEmail,
    required this.validatePassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff5A67F8);
    const secondaryColor = Color(0xffC73EF1);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        // subtle card glow to echo button colors
        gradient: LinearGradient(
          colors: [
            primaryColor.withAlpha((255 * 0.40).round()),
            Colors.transparent,
            Colors.transparent,
            secondaryColor.withAlpha((255 * 0.40).round()),
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((255 * 0.25).round()),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 35),
                    _CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 20),
                    _CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: !isPasswordVisible,
                      validator: validatePassword,
                      enabled: !isLoading,
                      suffixIcon: IconButton(
                        onPressed:
                            isLoading ? null : onTogglePasswordVisibility,
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white.withAlpha((255 * 0.50).round()),
                        ),
                      ),
                      onFieldSubmitted: (_) => onLogin(),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white.withAlpha((255 * 0.70).round()),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _LoginButton(
                      onPressed: isLoading ? null : onLogin,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 30),
                    // Demo credentials info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha((255 * 0.20).round()),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withAlpha((255 * 0.10).round()),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Demo Credentials',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Email: $mockEmail',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.white.withAlpha(
                                (255 * 0.70).round(),
                              ),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Password: $mockPassword',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.white.withAlpha(
                                (255 * 0.70).round(),
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Don't have an account text
                    Center(
                      child: TextButton(
                        onPressed: onSignUp,
                        child: Text(
                          "Don't have an account? Sign up.",
                          style: TextStyle(
                            color: Colors.white.withAlpha((255 * 0.70).round()),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withAlpha((255 * 0.50).round()),
        ),
        filled: true,
        fillColor: Colors.black.withAlpha((255 * 0.20).round()),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * 0.10).round()),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * 0.20).round()),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * 0.05).round()),
            width: 1.5,
          ),
        ),
        errorStyle: TextStyle(color: Colors.red.shade300, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// =========================
// CANVAS-BASED NEON BUTTON
// =========================
class _LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _LoginButton({this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff5A67F8);
    const secondary = Color(0xffC73EF1);
    const double height = 56;
    const double radius = 14;

    return GestureDetector(
      onTap: onPressed,
      child: RepaintBoundary(
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 1) Subtle outer halo (barely there, per reference)
              CustomPaint(
                painter: _NeonOuterHaloPainter(
                  radius: radius,
                  primary: primary,
                  secondary: secondary,
                ),
                child: const SizedBox.expand(),
              ),

              // 2) Glassy dark core (keeps center unfilled)
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: Colors.black.withAlpha((255 * 0.45).round()),
                  ),
                ),
              ),

              // 3) Inner ring + side washes (painted below text)
              CustomPaint(
                painter: _NeonInnerPainter(
                  radius: radius,
                  primary: primary,
                  secondary: secondary,
                ),
                child: const SizedBox.expand(),
              ),

              // 4) Text on absolute top
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child:
                      isLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withAlpha((255 * 0.99).round()),
                              ),
                            ),
                          )
                          : const _LoginLabel(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLabel extends StatelessWidget {
  const _LoginLabel();
  @override
  Widget build(BuildContext context) {
    return Text(
      'Log in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white.withAlpha((255 * 0.99).round()),
      ),
    );
  }
}

/// ================================
/// Painters
/// ================================

/// Soft, minimal outer bloom around the button edge (reference: barely-there),
/// plus a brighter core stroke.
class _NeonOuterHaloPainter extends CustomPainter {
  final double radius;
  final Color primary;
  final Color secondary;
  _NeonOuterHaloPainter({
    required this.radius,
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Reduced opacity to make the halo more subtle.
    final subtle =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..shader = LinearGradient(
            colors: [
              primary.withAlpha((255 * 0.10).round()),
              secondary.withAlpha((255 * 0.10).round()),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
          ..blendMode = BlendMode.plus;
    canvas.drawRRect(rrect, subtle);

    // Reduced opacity and stroke width to make the micro-bloom less intense.
    final micro =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..shader = LinearGradient(
            colors: [
              primary.withAlpha((255 * 0.40).round()),
              secondary.withAlpha((255 * 0.40).round()),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
          ..blendMode = BlendMode.plus;
    canvas.drawRRect(rrect, micro);

    // Crisp neon core on the very edge (no blur) — bright
    final core =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..shader = LinearGradient(
            colors: [primary.withAlpha(255), secondary.withAlpha(255)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect)
          ..blendMode = BlendMode.plus;
    canvas.drawRRect(rrect, core);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Strong inner ring + expanded side washes for more inward glow.
class _NeonInnerPainter extends CustomPainter {
  final double radius;
  final Color primary;
  final Color secondary;

  _NeonInnerPainter({
    required this.radius,
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // 1) Inner glow ring (bleeds inward): stronger
    final ringRect = rrect.deflate(1.0);
    final innerRing1 =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = 60
          ..shader = LinearGradient(
            colors: [primary.withAlpha(50), secondary.withAlpha(50)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 16)
          ..blendMode = BlendMode.plus;

    final innerRing2 =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..shader = LinearGradient(
            colors: [
              primary.withAlpha((255 * 0.95).round()),
              secondary.withAlpha((255 * 0.95).round()),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 8)
          ..blendMode = BlendMode.plus;

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(ringRect, innerRing1);
    canvas.drawRRect(ringRect.deflate(1.0), innerRing2);

    // 2) Inward halo washes: stronger on left/right, faint top/bottom

    // Left wash (blue side)
    final leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-size.width * 0.24, 0, size.width * 0.78, size.height),
      Radius.circular(radius),
    );
    final leftWash =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            colors: [
              primary.withAlpha((255 * 0.75).round()),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(leftRect.outerRect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 38)
          ..blendMode = BlendMode.plus;
    canvas.drawRRect(leftRect, leftWash);

    // Right wash (purple side)
    final rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.46, 0, size.width * 0.78, size.height),
      Radius.circular(radius),
    );
    final rightWash =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              secondary.withAlpha((255 * 0.75).round()),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rightRect.outerRect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 38)
          ..blendMode = BlendMode.plus;
    canvas.drawRRect(rightRect, rightWash);

    // faint top & bottom wash for realism (much weaker than sides)
    final topRect = Rect.fromLTWH(
      0,
      -size.height * 0.45,
      size.width,
      size.height * 0.55,
    );
    final topWash =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            colors: [
              Colors.white.withAlpha((255 * 0.08).round()),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(topRect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
          ..blendMode = BlendMode.plus;
    canvas.drawRect(topRect, topWash);

    final bottomRect = Rect.fromLTWH(
      0,
      size.height * 0.90,
      size.width,
      size.height * 0.55,
    );
    final bottomWash =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white.withAlpha((255 * 0.06).round()),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bottomRect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
          ..blendMode = BlendMode.plus;
    canvas.drawRect(bottomRect, bottomWash);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
