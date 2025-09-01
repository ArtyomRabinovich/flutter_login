import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A button with a custom-painted, glowing "neon" effect.
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double height;
  final double width;
  final double fontSize;

  const NeonButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.height = 56,
    this.width = double.infinity,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The button is disabled if it's loading or has no onPressed callback.
    final bool isDisabled = isLoading || onPressed == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: RepaintBoundary(
          child: SizedBox(
            height: height,
            width: width,
            child: isPrimary ? _buildPrimaryButton() : _buildSecondaryButton(),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    const primary = Color(0xff5A67F8);
    const secondary = Color(0xffC73EF1);
    const double radius = 14;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1) Subtle outer halo
        CustomPaint(
          painter: _NeonOuterHaloPainter(
            radius: radius,
            primary: primary,
            secondary: secondary,
          ),
          child: const SizedBox.expand(),
        ),
        // 2) Glassy dark core
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withAlpha((255 * 0.45).round()),
            ),
          ),
        ),
        // 3) Inner ring + side washes
        CustomPaint(
          painter: _NeonInnerPainter(
            radius: radius,
            primary: primary,
            secondary: secondary,
          ),
          child: const SizedBox.expand(),
        ),
        // 4) Text or loading indicator
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : _ButtonLabel(text: text, fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton() {
    const double radius = 14;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((255 * 0.3).round()),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withAlpha((255 * 0.2).round()),
              width: 1.5,
            ),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : _ButtonLabel(text: text, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  final String text;
  final double fontSize;

  const _ButtonLabel({required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white.withAlpha((255 * 0.95).round()),
        letterSpacing: 0.5,
      ),
    );
  }
}

// Custom Painters for the primary button's neon effect (from login_screen.dart)

/// Soft, minimal outer bloom around the button edge.
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

    final subtle = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..shader = LinearGradient(
        colors: [primary.withAlpha((255 * 0.1).round()), secondary.withAlpha((255 * 0.1).round())],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
      ..blendMode = BlendMode.plus;
    canvas.drawRRect(rrect, subtle);

    final micro = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..shader = LinearGradient(
        colors: [primary.withAlpha((255 * 0.4).round()), secondary.withAlpha((255 * 0.4).round())],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..blendMode = BlendMode.plus;
    canvas.drawRRect(rrect, micro);

    final core = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..shader = LinearGradient(
        colors: [primary, secondary],
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

    final ringRect = rrect.deflate(1.0);
    final innerRing1 = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 60
      ..shader = LinearGradient(
        colors: [primary.withAlpha((255 * 0.2).round()), secondary.withAlpha((255 * 0.2).round())],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 16)
      ..blendMode = BlendMode.plus;

    final innerRing2 = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..shader = LinearGradient(
        colors: [primary.withAlpha((255 * 0.95).round()), secondary.withAlpha((255 * 0.95).round())],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 8)
      ..blendMode = BlendMode.plus;

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(ringRect, innerRing1);
    canvas.drawRRect(ringRect.deflate(1.0), innerRing2);

    final leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-size.width * 0.24, 0, size.width * 0.78, size.height),
      Radius.circular(radius),
    );
    final leftWash = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [primary.withAlpha((255 * 0.75).round()), Colors.transparent],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(leftRect.outerRect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 38)
      ..blendMode = BlendMode.plus;
    canvas.drawRRect(leftRect, leftWash);

    final rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.46, 0, size.width * 0.78, size.height),
      Radius.circular(radius),
    );
    final rightWash = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [Colors.transparent, secondary.withAlpha((255 * 0.75).round())],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rightRect.outerRect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 38)
      ..blendMode = BlendMode.plus;
    canvas.drawRRect(rightRect, rightWash);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
