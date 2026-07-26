import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/bi.dart';

enum DocCategory { all, reports, acts, policies }

const Map<DocCategory, Bi> kDocCategoryLabels = {
  DocCategory.all: Bi('All', 'सर्व'),
  DocCategory.reports: Bi('Reports', 'अहवाल'),
  DocCategory.acts: Bi('Acts & Rules', 'कायदे व नियम'),
  DocCategory.policies: Bi('Policies', 'धोरणे'),
};

class DocumentItem {
  final Bi title;
  final Bi meta;
  final DocCategory category;
  final Color tint;
  const DocumentItem({required this.title, required this.meta, required this.category, required this.tint});
}

const List<DocumentItem> kDocuments = [
  DocumentItem(
    title: Bi('Annual Report 2024-25', 'वार्षिक अहवाल २०२४-२५'),
    meta: Bi('PDF · 2.4 MB · Reports', 'PDF · 2.4 MB · अहवाल'),
    category: DocCategory.reports,
    tint: AppColors.navy,
  ),
  DocumentItem(
    title: Bi('Government Resolution - GR/2026/14', 'शासन निर्णय - GR/2026/14'),
    meta: Bi('PDF · 1.8 MB · Acts & Rules', 'PDF · 1.8 MB · कायदे व नियम'),
    category: DocCategory.acts,
    tint: AppColors.saffron,
  ),
  DocumentItem(
    title: Bi('Minority Commission Act, 2004', 'अल्पसंख्याक आयोग कायदा, २००४'),
    meta: Bi('PDF · 3.1 MB · Acts & Rules', 'PDF · 3.1 MB · कायदे व नियम'),
    category: DocCategory.acts,
    tint: AppColors.saffron,
  ),
  DocumentItem(
    title: Bi('Scholarship Disbursement Policy', 'शिष्यवृत्ती वितरण धोरण'),
    meta: Bi('PDF · 2.0 MB · Policies', 'PDF · 2.0 MB · धोरणे'),
    category: DocCategory.policies,
    tint: AppColors.green,
  ),
  DocumentItem(
    title: Bi('RTI Handbook', 'माहिती अधिकार पुस्तिका'),
    meta: Bi('PDF · 1.2 MB · Policies', 'PDF · 1.2 MB · धोरणे'),
    category: DocCategory.policies,
    tint: AppColors.green,
  ),
  DocumentItem(
    title: Bi('Grievance Redressal Report Q1 2026', 'तक्रार निवारण अहवाल Q1 2026'),
    meta: Bi('PDF · 900 KB · Reports', 'PDF · 900 KB · अहवाल'),
    category: DocCategory.reports,
    tint: AppColors.navy,
  ),
];
