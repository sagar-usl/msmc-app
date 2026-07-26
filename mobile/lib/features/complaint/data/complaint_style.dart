import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'complaint_models.dart';

class StatusStyle {
  final Color background;
  final Color foreground;
  const StatusStyle(this.background, this.foreground);
}

const Map<ComplaintStatus, StatusStyle> kStatusStyles = {
  ComplaintStatus.underReview: StatusStyle(Color(0x26FF9933), AppColors.saffronDark),
  ComplaintStatus.accepted: StatusStyle(Color(0x1F2E7D32), AppColors.green),
  ComplaintStatus.rejected: StatusStyle(Color(0x1FC0392B), AppColors.red),
  ComplaintStatus.caseOnboard: StatusStyle(Color(0x26FF9933), AppColors.saffronDark),
  ComplaintStatus.finalHearingScheduled: StatusStyle(Color(0x26FF9933), AppColors.saffronDark),
  ComplaintStatus.disposedOf: StatusStyle(Color(0x38FFCC00), AppColors.gold),
};

String statusLabel(ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.underReview:
      return 'complaint.statusUnderReview'.tr();
    case ComplaintStatus.accepted:
      return 'complaint.statusAccepted'.tr();
    case ComplaintStatus.rejected:
      return 'complaint.statusRejected'.tr();
    case ComplaintStatus.caseOnboard:
      return 'complaint.statusCaseOnboard'.tr();
    case ComplaintStatus.finalHearingScheduled:
      return 'complaint.statusFinalHearingScheduled'.tr();
    case ComplaintStatus.disposedOf:
      return 'complaint.statusDisposedOf'.tr();
  }
}

String categoryLabel(ComplaintCategory category) {
  switch (category) {
    case ComplaintCategory.documents:
      return 'complaint.catDocuments'.tr();
    case ComplaintCategory.education:
      return 'complaint.catEducation'.tr();
    case ComplaintCategory.schemeDelay:
      return 'complaint.catSchemeDelay'.tr();
    case ComplaintCategory.corruption:
      return 'complaint.catCorruption'.tr();
    case ComplaintCategory.other:
      return 'complaint.catOther'.tr();
  }
}
