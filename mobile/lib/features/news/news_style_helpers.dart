import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

Color tagColor(String tag) => switch (tag) {
  'SCHEME_UPDATE' => AppColors.navy,
  'NOTICE'        => AppColors.saffronDark,
  'EVENT'         => AppColors.green,
  _               => AppColors.navy,
};

String tagLabel(String tag, String lang) => switch (tag) {
  'SCHEME_UPDATE' => lang == 'mr' ? 'योजना अद्यतन' : 'Scheme Update',
  'NOTICE'        => lang == 'mr' ? 'सूचना'         : 'Notice',
  'EVENT'         => lang == 'mr' ? 'कार्यक्रम'      : 'Event',
  _               => tag,
};
