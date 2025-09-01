import 'dart:ui';
import 'package:flutter/material.dart';

/// A container with a "frosted glass" effect, used as the base for most UI surfaces.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool hasBorder;

  const GlassContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.hasBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5A67F8);
    const secondaryColor = Color(0xFFC73EF1);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(24.0);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        // A subtle gradient outline that mimics the neon glow of buttons.
        gradient: LinearGradient(
          colors: [
            primaryColor.withAlpha((255 * 0.15).round()),
            Colors.transparent,
            Colors.transparent,
            secondaryColor.withAlpha((255 * 0.15).round()),
          ],
          stops: const [0.0, 0.4, 0.6, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      // Use a nested container with a 1.5px padding to create the "border" effect
      child: Padding(
        padding: hasBorder ? const EdgeInsets.all(1.5) : EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((255 * 0.25).round()),
                // The inner border is handled by the parent's padding
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
