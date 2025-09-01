import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// A text form field with the app's custom "glass" styling.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;


  const CustomTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.style,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5A67F8);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      style: style ?? GoogleFonts.inter(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withAlpha((255 * 0.5).round()),
        ),
        filled: true,
        fillColor: Colors.black.withAlpha((255 * 0.2).round()),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: IconTheme(
                  data: IconThemeData(color: Colors.white.withAlpha((255 * 0.5).round())),
                  child: prefixIcon!,
                ),
              )
            : null,
        suffixIcon: suffixIcon,
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
            color: primaryColor.withAlpha((255 * 0.8).round()),
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
      ),
    );
  }
}
