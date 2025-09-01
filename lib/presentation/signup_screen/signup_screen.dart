import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/background_shape.dart';
import '../../widgets/shared/glass_container.dart';
import '../../routes/app_routes.dart';
import '../../widgets/shared/neon_button.dart';
import '../../widgets/shared/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  double _passwordStrength = 0;

  late AnimationController _shapesAnimationController;
  late Animation<double> _shapesAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _passwordController.addListener(_updatePasswordStrength);
  }

  void _setupAnimations() {
    _shapesAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _shapesAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _shapesAnimationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shapesAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    String password = _passwordController.text;
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) strength += 0.25;
    setState(() {
      _passwordStrength = (strength).clamp(0, 1);
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate() || !_agreedToTerms) {
      if (!_agreedToTerms) {
        _showErrorToast("You must agree to the terms to continue.");
      }
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    // Navigate to 2FA screen after successful signup
    Navigator.pushNamed(context, AppRoutes.twoFactor);
  }

  void _showErrorToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade600,
    ));
  }

  @override
  Widget build(BuildContext context) {
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
                    child: const BackgroundShape(color: Color(0xFFC73EF1), size: 200),
                  ),
                  Positioned(
                    bottom: 15.h,
                    right: 70.w * _shapesAnimation.value - 40.w,
                    child: const BackgroundShape(color: Color(0xFF5A67F8), size: 250),
                  ),
                ],
              );
            },
          ),
          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlassContainer(
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(12),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // UI Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: GlassContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Create Account',
                          style: GoogleFonts.inter(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 1.h),
                      Text('Join us to start your journey.',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.7))),
                      SizedBox(height: 4.h),
                      _buildSocialButtons(),
                      SizedBox(height: 3.h),
                      _buildDivider(),
                      SizedBox(height: 3.h),
                      CustomTextField(
                          controller: _nameController,
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                          validator: (v) =>
                              v!.isEmpty ? 'Name is required' : null),
                      SizedBox(height: 2.h),
                      CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v!.isEmpty) return 'Email is required';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          }),
                      SizedBox(height: 2.h),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: !_isPasswordVisible,
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.withOpacity(0.5)),
                          onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        validator: (v) => v!.length < 8
                            ? 'Password must be at least 8 characters'
                            : null,
                      ),
                      SizedBox(height: 2.h),
                      _buildPasswordStrengthIndicator(),
                      SizedBox(height: 3.h),
                      _buildTermsAndConditions(),
                      SizedBox(height: 4.h),
                      NeonButton(
                        text: 'Create Account',
                        onPressed: _handleSignUp,
                        isLoading: _isLoading,
                      ),
                      SizedBox(height: 3.h),
                      _buildLoginLink(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
            child: NeonButton(
                text: 'Google',
                onPressed: () {},
                isPrimary: false,
                fontSize: 14,
                child: Icon(Icons.android, color: Colors.white))), // Placeholder
        SizedBox(width: 2.w),
        Expanded(
            child: NeonButton(
                text: 'Apple',
                onPressed: () {},
                isPrimary: false,
                fontSize: 14,
                child: Icon(Icons.apple, color: Colors.white))),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text('OR',
              style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.5), fontSize: 12.sp)),
        ),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password Strength',
            style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.7), fontSize: 11.sp)),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey.withOpacity(0.3),
          color: Color.lerp(Colors.red, Colors.green, _passwordStrength),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) => setState(() => _agreedToTerms = value!),
          checkColor: Colors.black,
          fillColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7), fontSize: 11.sp),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                        color: Color(0xFF5A67F8),
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Navigate to ToS');
                      }),
                TextSpan(text: ' and '),
                TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                        color: Color(0xFF5A67F8),
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Navigate to Privacy Policy');
                      }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.7), fontSize: 12.sp),
        children: [
          TextSpan(text: 'Already have an account? '),
          TextSpan(
              text: 'Log In',
              style: TextStyle(
                  color: Color(0xFF5A67F8), fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, AppRoutes.login);
                }),
        ],
      ),
    );
  }
}
