import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/timeline_builder.dart';

class StatusTimeline extends StatelessWidget {
  final List<TimelineStep> steps;
  const StatusTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.map((step) {
        final isPending = step.state == TimelineStepState.pending;
        final dotBg = step.state == TimelineStepState.done
            ? AppColors.green
            : step.state == TimelineStepState.current
                ? step.accentColor
                : const Color(0xFFE2E6EC);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: dotBg,
                    shape: BoxShape.circle,
                    boxShadow: step.state == TimelineStepState.current
                        ? [BoxShadow(color: step.accentColor.withValues(alpha: 0.2), blurRadius: 0, spreadRadius: 4)]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: step.state == TimelineStepState.done
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : step.state == TimelineStepState.current
                          ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                          : null,
                ),
                if (step.showConnector)
                  Container(
                    width: 2,
                    constraints: const BoxConstraints(minHeight: 22),
                    color: isPending ? const Color(0xFFECEFF3) : const Color(0xFFC7D0DD),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.label,
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: isPending ? const Color(0xFFB5BAC2) : AppColors.textPrimary),
                    ),
                    if (step.sub != null) ...[
                      const SizedBox(height: 2),
                      Text(step.sub!, style: const TextStyle(fontSize: 11, color: AppColors.textFaint)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
