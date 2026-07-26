import 'package:flutter/material.dart';

/// Small uppercase, letter-spaced eyebrow label used above section content
/// (e.g. "CHAIRMAN'S MESSAGE", "ABOUT THE DEPARTMENT").
class SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const SectionHeader({
    super.key,
    required this.label,
    required this.color,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
