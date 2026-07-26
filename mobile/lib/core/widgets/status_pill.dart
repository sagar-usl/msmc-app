import 'package:flutter/material.dart';

/// Colored pill badge with an optional leading dot — used for complaint
/// status ("Under Review", "Disposed Of"...) and news tags ("Notice", "Event"...).
class StatusPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final bool showDot;
  final bool uppercase;

  const StatusPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.showDot = false,
    this.uppercase = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            uppercase ? label.toUpperCase() : label,
            style: TextStyle(
              color: foreground,
              fontSize: uppercase ? 9.5 : 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: uppercase ? 0.4 : 0,
            ),
          ),
        ],
      ),
    );
  }
}
