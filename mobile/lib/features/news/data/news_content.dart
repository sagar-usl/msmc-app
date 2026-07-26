import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/bi.dart';

enum NewsTag { schemeUpdate, notice, event }

const Map<NewsTag, Bi> kNewsTagLabels = {
  NewsTag.schemeUpdate: Bi('Scheme Update', 'योजना अद्यतन'),
  NewsTag.notice: Bi('Notice', 'सूचना'),
  NewsTag.event: Bi('Event', 'कार्यक्रम'),
};

const Map<NewsTag, Color> kNewsTagColors = {
  NewsTag.schemeUpdate: AppColors.navy,
  NewsTag.notice: AppColors.saffronDark,
  NewsTag.event: AppColors.green,
};

class NewsItem {
  final NewsTag tag;
  final Bi date;
  final Bi title;
  final Bi snippet;
  const NewsItem({required this.tag, required this.date, required this.title, required this.snippet});
}

const List<NewsItem> kNewsItems = [
  NewsItem(
    tag: NewsTag.schemeUpdate,
    date: Bi('2 Jul 2026', '२ जुलै २०२६'),
    title: Bi('Post-Matric Scholarship 2026-27 applications now open', 'मॅट्रिकोत्तर शिष्यवृत्ती २०२६-२७ साठी अर्ज सुरू'),
    snippet: Bi('Students can apply on the National Scholarship Portal until 30 Sept 2026.', 'विद्यार्थी ३० सप्टेंबर २०२६ पर्यंत राष्ट्रीय शिष्यवृत्ती पोर्टलवर अर्ज करू शकतात.'),
  ),
  NewsItem(
    tag: NewsTag.notice,
    date: Bi('28 Jun 2026', '२८ जून २०२६'),
    title: Bi('Revised income eligibility limits for welfare schemes', 'कल्याण योजनांसाठी सुधारित उत्पन्न पात्रता मर्यादा'),
    snippet: Bi('Updated income criteria effective from the current financial year.', 'चालू आर्थिक वर्षापासून सुधारित उत्पन्न निकष लागू.'),
  ),
  NewsItem(
    tag: NewsTag.event,
    date: Bi('20 Jun 2026', '२० जून २०२६'),
    title: Bi('District awareness camps scheduled across Maharashtra', 'महाराष्ट्रभर जिल्हास्तरीय जनजागृती शिबिरे नियोजित'),
    snippet: Bi('Camps to help citizens understand and apply for available schemes.', 'नागरिकांना योजना समजून घेण्यास व अर्ज करण्यास मदत करणारी शिबिरे.'),
  ),
  NewsItem(
    tag: NewsTag.notice,
    date: Bi('10 Jun 2026', '१० जून २०२६'),
    title: Bi('Helpline hours extended for grievance support', 'तक्रार सहाय्यासाठी हेल्पलाइन वेळ वाढवली'),
    snippet: Bi('The commission helpline is now available 8 AM - 8 PM, all days.', 'आयोगाची हेल्पलाइन आता सकाळी ८ ते रात्री ८ पर्यंत उपलब्ध.'),
  ),
];
