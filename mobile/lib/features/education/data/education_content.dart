import '../../../core/localization/bi.dart';

class EducationItem {
  final Bi title;
  final Bi desc;
  const EducationItem({required this.title, required this.desc});
}

const List<EducationItem> kEducationItems = [
  EducationItem(title: Bi('Pre-Matric Scholarship', 'मॅट्रिकपूर्व शिष्यवृत्ती'), desc: Bi('For students in classes 1-10', 'इयत्ता १ ते १० च्या विद्यार्थ्यांसाठी')),
  EducationItem(title: Bi('Post-Matric Scholarship', 'मॅट्रिकोत्तर शिष्यवृत्ती'), desc: Bi('For undergraduate & postgraduate students', 'पदवी व पदव्युत्तर विद्यार्थ्यांसाठी')),
  EducationItem(title: Bi('Merit-cum-Means Scholarship', 'गुणवत्ता-सह-गरजाधारित शिष्यवृत्ती'), desc: Bi('For professional & technical courses', 'व्यावसायिक व तांत्रिक अभ्यासक्रमांसाठी')),
  EducationItem(title: Bi('NSP Scholarship', 'NSP शिष्यवृत्ती'), desc: Bi('Apply via National Scholarship Portal', 'राष्ट्रीय शिष्यवृत्ती पोर्टलवर अर्ज करा')),
  EducationItem(title: Bi('How to Apply', 'अर्ज कसा करावा'), desc: Bi('Step-by-step application guide', 'टप्प्याटप्प्याने अर्ज मार्गदर्शक')),
];
