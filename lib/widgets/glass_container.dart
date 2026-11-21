import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 14,
    this.color,
    this.padding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
