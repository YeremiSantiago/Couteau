import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final List<Color>? borderGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: borderGradient != null
              ? [borderGradient![0].withOpacity(0.4), borderGradient![1].withOpacity(0.2)]
              : [AppTheme.glassBorder, AppTheme.glassBorder.withOpacity(0.05)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.2), // border width
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.glassWhite,
                borderRadius: BorderRadius.circular(borderRadius - 1),
              ),
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
