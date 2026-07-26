import '../../../core/localization/bi.dart';

class CarouselSlide {
  final String image;
  final Bi title;
  final Bi desc;
  const CarouselSlide({required this.image, required this.title, required this.desc});
}

const List<CarouselSlide> kCarouselSlides = [
  CarouselSlide(
    image: 'assets/images/slide-heritage.png',
    title: Bi('Unity in Diversity', 'विविधतेत एकता'),
    desc: Bi('Celebrating the shared heritage of all faiths', 'सर्व धर्मांच्या सामायिक वारशाचा उत्सव'),
  ),
  CarouselSlide(
    image: 'assets/images/slide-education.jpg',
    title: Bi('Learning Without Limits', 'शिक्षणाला मर्यादा नाहीत'),
    desc: Bi('Scholarships opening doors for every student', 'प्रत्येक विद्यार्थ्यासाठी शिष्यवृत्तीच्या संधी'),
  ),
  CarouselSlide(
    image: 'assets/images/slide-skill.jpg',
    title: Bi('Building Livelihoods', 'उपजीविकेची उभारणी'),
    desc: Bi('Training programs for self-reliance', 'स्वावलंबनासाठी प्रशिक्षण कार्यक्रम'),
  ),
  CarouselSlide(
    image: 'assets/images/slide-welfare.jpg',
    title: Bi('Support That Reaches You', 'तुमच्यापर्यंत पोहोचणारे सहाय्य'),
    desc: Bi('Housing, health and financial assistance', 'घरकुल, आरोग्य व आर्थिक सहाय्य'),
  ),
];

const List<Bi> kFooterLinks = [
  Bi('Feedback', 'अभिप्राय'),
  Bi('Website Policies', 'संकेतस्थळ धोरणे'),
  Bi('Contact Us', 'संपर्क'),
  Bi('Help', 'मदत'),
];
