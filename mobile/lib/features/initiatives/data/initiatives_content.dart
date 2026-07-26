import '../../../core/localization/bi.dart';

class InitiativeItem {
  final Bi title;
  final Bi district;
  final Bi desc;
  final String image;
  const InitiativeItem({required this.title, required this.district, required this.desc, required this.image});
}

const List<InitiativeItem> kInitiatives = [
  InitiativeItem(
    title: Bi('Skill Development Program', 'कौशल्य विकास कार्यक्रम'),
    district: Bi('Sambhaji Nagar', 'संभाजी नगर'),
    desc: Bi('Vocational training and job placement support for minority youth.', 'अल्पसंख्याक युवकांसाठी व्यावसायिक प्रशिक्षण व रोजगार सहाय्य.'),
    image: 'assets/images/init-skill.jpg',
  ),
  InitiativeItem(
    title: Bi('Women Empowerment Cell', 'महिला सक्षमीकरण कक्ष'),
    district: Bi('Nashik', 'नाशिक'),
    desc: Bi('Micro-credit, self-help groups and entrepreneurship support for women.', 'महिलांसाठी सूक्ष्म-कर्ज, बचत गट व उद्योजकता सहाय्य.'),
    image: 'assets/images/init-women.jpg',
  ),
  InitiativeItem(
    title: Bi('Youth Development Mission', 'युवा विकास मिशन'),
    district: Bi('Beed', 'बीड'),
    desc: Bi('Career counselling, competitive exam coaching and mentorship.', 'करिअर मार्गदर्शन, स्पर्धा परीक्षा प्रशिक्षण व मार्गदर्शन.'),
    image: 'assets/images/init-youth.jpg',
  ),
  InitiativeItem(
    title: Bi('Community Outreach Drives', 'सामुदायिक जनजागृती मोहीम'),
    district: Bi('Bhandara', 'भंडारा'),
    desc: Bi('District-level camps to raise awareness of schemes and entitlements.', 'योजना व हक्कांबाबत जनजागृतीसाठी जिल्हास्तरीय शिबिरे.'),
    image: 'assets/images/init-community.jpg',
  ),
];
