import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/shared/background_shape.dart';
import '../../widgets/shared/glass_container.dart';
import '../../widgets/shared/neon_button.dart';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({Key? key}) : super(key: key);

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen>
    with TickerProviderStateMixin {
  late AnimationController _shapesAnimationController;
  late Animation<double> _shapesAnimation;
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    setState(() => _errorMessage = '');
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    // If all fields are filled, attempt to verify
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _handleVerify();
    }
  }

  Future<void> _handleVerify() async {
    FocusScope.of(context).unfocus();
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits.');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    // Mock verification
    if (code == '123456') {
      // Success
      print('Verification successful!');
      // TODO: Navigate to home screen
    } else {
      setState(() {
        _errorMessage = 'Invalid code. Please try again.';
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      });
    }

    setState(() => _isLoading = false);
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
           // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: NeonButton(
                width: 50,
                height: 50,
                isPrimary: false,
                onPressed: () => Navigator.pop(context),
                text: '',
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: GlassContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.shield_outlined,
                        color: Colors.white, size: 12.w),
                    SizedBox(height: 2.h),
                    Text('2-Factor Authentication',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 1.h),
                    Text(
                        'Enter the 6-digit code sent to your email/phone.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7))),
                    SizedBox(height: 4.h),
                    _buildCodeInput(),
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(_errorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.red.shade300, fontSize: 12.sp)),
                    ],
                    SizedBox(height: 4.h),
                    NeonButton(
                      text: 'Verify',
                      onPressed: _handleVerify,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 3.h),
                    _buildBottomLinks(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 12.w,
            height: 12.w,
            child: CustomTextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              hintText: '',
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (v) => _onCodeChanged(v, index),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.zero,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _isLoading ? null : () {},
          child: Text('Resend Code',
              style:
                  GoogleFonts.inter(color: Colors.white.withOpacity(0.7))),
        ),
        TextButton(
          onPressed: _isLoading ? null : () {},
          child: Text('Use Backup Code',
              style:
                  GoogleFonts.inter(color: Colors.white.withOpacity(0.7))),
        ),
      ],
    );
  }
}

// A more customized text field for the OTP boxes
class CustomOtpTextField extends CustomTextField {
  final TextAlign textAlign;
  final TextStyle? style;
  final EdgeInsets contentPadding;
  final List<TextInputFormatter>? inputFormatters;

  const CustomOtpTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onFieldSubmitted,
    bool enabled = true,
    this.textAlign = TextAlign.left,
    this.style,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    this.inputFormatters,
  }) : super(
          controller: controller,
          focusNode: focusNode,
          hintText: '',
          enabled: enabled,
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: TextInputType.number,
        );

  @override
  Widget build(BuildContext context) {
    // Re-implementing build method to add specific properties
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      onChanged: onFieldSubmitted, // Using onChanged for immediate focus shift
      style: style,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        contentPadding: contentPadding,
        counterText: '', // Hide the counter
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
         focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFF5A67F8).withOpacity(0.8),
            width: 2,
          ),
        ),
      ),
      maxLength: 1,
    );
  }
}
