import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Rounded white card with the soft navy-tinted shadow used throughout the
/// prototype (`box-shadow: 0 2px 14px rgba(11,61,145,0.08)` and variants).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double shadowOpacity;
  final double shadowBlur;
  final Offset shadowOffset;
  final Color? color;
  final Border? border;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 18,
    this.shadowOpacity = 0.08,
    this.shadowBlur = 14,
    this.shadowOffset = const Offset(0, 2),
    this.color,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: [
          BoxShadow(
            color: AppColors.navyTint(shadowOpacity),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
