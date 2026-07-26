import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/complaint_models.dart';

enum TimelineStepState { done, current, pending }

class TimelineStep {
  final String label;
  final String? sub;
  final TimelineStepState state;
  final Color accentColor;
  final bool showConnector;

  const TimelineStep({
    required this.label,
    this.sub,
    required this.state,
    required this.accentColor,
    this.showConnector = true,
  });
}

/// Server-side (well, here client-side-standing-in-for-server) replacement
/// for the prototype's `buildTimeline()` — walks a complaint's status +
/// hearing fields into an ordered progress list. Once the backend lands
/// (Phase 4 of the build plan) this becomes a straight read of
/// `complaint_status_history` instead of being re-derived on the client.
List<TimelineStep> buildTimeline(Complaint c, String lang, {
  required String tlSubmitted,
  required String tlUnderReview,
  required String tlRejected,
  required String tlClosed,
  required String tlAccepted,
  required String tlHearingScheduled,
  required String tlCaseOnboard,
  required String tlFinalHearingScheduled,
  required String tlVerdictUploaded,
  required String tlDisposedOf,
}) {
  final steps = <TimelineStep>[];

  steps.add(TimelineStep(label: tlSubmitted, sub: c.date.of(lang), state: TimelineStepState.done, accentColor: AppColors.green));

  if (c.status == ComplaintStatus.rejected) {
    steps.add(TimelineStep(label: tlUnderReview, state: TimelineStepState.done, accentColor: AppColors.green));
    steps.add(TimelineStep(label: tlRejected, sub: tlClosed, state: TimelineStepState.current, accentColor: AppColors.red, showConnector: false));
    return steps;
  }

  const order = [
    ComplaintStatus.underReview,
    ComplaintStatus.accepted,
    ComplaintStatus.caseOnboard,
    ComplaintStatus.finalHearingScheduled,
    ComplaintStatus.disposedOf,
  ];
  final idx = order.indexOf(c.status);

  TimelineStepState stateFor(int stepIdx) {
    if (idx > stepIdx) return TimelineStepState.done;
    if (idx == stepIdx) return TimelineStepState.current;
    return TimelineStepState.pending;
  }

  steps.add(TimelineStep(label: tlUnderReview, state: stateFor(0), accentColor: AppColors.saffronDark));
  steps.add(TimelineStep(label: tlAccepted, state: stateFor(1), accentColor: AppColors.green));
  steps.add(TimelineStep(
    label: tlHearingScheduled,
    sub: c.hearing != null ? '${c.hearing!.date} · ${c.hearing!.location.of(lang)}' : null,
    state: c.hearing != null ? TimelineStepState.done : TimelineStepState.pending,
    accentColor: AppColors.navy,
  ));
  steps.add(TimelineStep(label: tlCaseOnboard, state: stateFor(2), accentColor: AppColors.saffronDark));
  steps.add(TimelineStep(
    label: tlFinalHearingScheduled,
    sub: c.hearing2 != null ? '${c.hearing2!.date} · ${c.hearing2!.location.of(lang)}' : null,
    state: c.hearing2 != null ? TimelineStepState.done : TimelineStepState.pending,
    accentColor: AppColors.navy,
  ));
  steps.add(TimelineStep(
    label: tlVerdictUploaded,
    sub: c.verdictFile,
    state: c.verdictFile != null ? TimelineStepState.done : TimelineStepState.pending,
    accentColor: AppColors.navy,
  ));
  steps.add(TimelineStep(
    label: tlDisposedOf,
    state: idx == 4 ? TimelineStepState.current : TimelineStepState.pending,
    accentColor: AppColors.gold,
    showConnector: false,
  ));

  return steps;
}
