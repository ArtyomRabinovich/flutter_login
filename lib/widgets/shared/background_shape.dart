import 'dart:ui';
import 'package:flutter/material.dart';

// Animated, blurred background shape that provides the "aurora" effect.
class BackgroundShape extends StatelessWidget {
  final Color color;
  final double size;

  const BackgroundShape({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

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
