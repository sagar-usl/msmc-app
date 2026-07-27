import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Returns (backgroundColor, foregroundColor) for a status badge.
(Color, Color) statusColors(String status) => switch (status) {
  'UNDER_REVIEW'            => (const Color(0xFFFFF3CD), const Color(0xFF856404)),
  'ACCEPTED'                => (const Color(0xFFD1E7DD), AppColors.green),
  'REJECTED'                => (const Color(0xFFF8D7DA), AppColors.red),
  'CASE_ONBOARD'            => (const Color(0xFFCFE2FF), AppColors.navy),
  'FINAL_HEARING_SCHEDULED' => (const Color(0xFFD3E3FD), AppColors.navyLight),
  'DISPOSED_OF'             => (const Color(0xFFD1E7DD), AppColors.green),
  _                         => (const Color(0xFFF0F0F0), AppColors.textMuted),
};

String statusLabel(String status, String lang) {
  final en = switch (status) {
    'UNDER_REVIEW'            => 'Under Review',
    'ACCEPTED'                => 'Accepted',
    'REJECTED'                => 'Rejected',
    'CASE_ONBOARD'            => 'Case Onboard',
    'FINAL_HEARING_SCHEDULED' => 'Final Hearing Scheduled',
    'DISPOSED_OF'             => 'Disposed Of',
    _                         => status,
  };
  if (lang != 'mr') return en;
  return switch (status) {
    'UNDER_REVIEW'            => 'पुनरावलोकनाधीन',
    'ACCEPTED'                => 'स्वीकृत',
    'REJECTED'                => 'नाकारलेले',
    'CASE_ONBOARD'            => 'केस सुरू',
    'FINAL_HEARING_SCHEDULED' => 'अंतिम सुनावणी',
    'DISPOSED_OF'             => 'निकाल',
    _                         => status,
  };
}

String categoryLabel(String category, String lang) {
  final en = switch (category) {
    'DOCUMENTS'   => 'Documents',
    'EDUCATION'   => 'Education',
    'SCHEME_DELAY'=> 'Scheme Delay',
    'CORRUPTION'  => 'Corruption',
    'OTHER'       => 'Other',
    _             => category,
  };
  if (lang != 'mr') return en;
  return switch (category) {
    'DOCUMENTS'   => 'कागदपत्रे',
    'EDUCATION'   => 'शिक्षण',
    'SCHEME_DELAY'=> 'योजना विलंब',
    'CORRUPTION'  => 'भ्रष्टाचार',
    'OTHER'       => 'इतर',
    _             => category,
  };
}

// API category names → server-side enum strings
const Map<String, String> kCategoryApiValues = {
  'Documents':    'DOCUMENTS',
  'Education':    'EDUCATION',
  'Scheme Delay': 'SCHEME_DELAY',
  'Corruption':   'CORRUPTION',
  'Other':        'OTHER',
};
