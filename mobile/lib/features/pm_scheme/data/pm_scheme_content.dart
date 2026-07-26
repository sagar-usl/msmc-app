import '../../../core/localization/bi.dart';

class PmSchemePoint {
  final Bi title;
  final Bi collapsedSummary;
  final Bi detail;
  const PmSchemePoint({required this.title, required this.collapsedSummary, required this.detail});
}

const List<Bi> kPmSchemeCommunities = [
  Bi('Muslims', 'मुस्लिम'),
  Bi('Christians', 'ख्रिश्चन'),
  Bi('Sikhs', 'शीख'),
  Bi('Buddhists', 'बौद्ध'),
  Bi('Parsis', 'पारशी'),
  Bi('Jains', 'जैन'),
];

const List<Bi> kPmSchemeFocusAreas = [
  Bi('Education', 'शिक्षण'),
  Bi('Employment', 'रोजगार'),
  Bi('Skill Development', 'कौशल्य विकास'),
  Bi('Housing', 'गृहनिर्माण'),
  Bi('Financial Inclusion', 'आर्थिक समावेशन'),
  Bi('Social Justice', 'सामाजिक न्याय'),
];

const List<PmSchemePoint> kPmSchemePoints = [
  PmSchemePoint(
    title: Bi('Enhancing Educational Opportunities', 'शैक्षणिक संधींचा विस्तार'),
    collapsedSummary: Bi('Wider access to schools and higher education for minority students.', 'अल्पसंख्याक विद्यार्थ्यांसाठी शाळा व उच्च शिक्षणाचा व्यापक प्रवेश.'),
    detail: Bi(
      'Government works to expand school and college access in minority-concentrated areas, improve enrolment and reduce drop-out rates through targeted support.',
      'अल्पसंख्याकबहुल भागात शाळा व महाविद्यालय प्रवेश वाढवणे, नोंदणी सुधारणे आणि गळतीचे प्रमाण कमी करण्यासाठी शासन विशेष सहाय्य पुरवते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Improving Availability of Early Childhood Education', 'बालवाडी शिक्षणाची उपलब्धता सुधारणे'),
    collapsedSummary: Bi('More Anganwadi centres in minority-concentrated areas.', 'अल्पसंख्याकबहुल भागात अधिक अंगणवाडी केंद्रे.'),
    detail: Bi(
      'Priority is given to opening Anganwadi centres under ICDS in areas with significant minority population to strengthen early childhood care and education.',
      'लक्षणीय अल्पसंख्याक लोकसंख्या असलेल्या भागात ICDS अंतर्गत अंगणवाडी केंद्रे सुरू करण्यास प्राधान्य दिले जाते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Promotion of Urdu Education', 'उर्दू शिक्षणाला प्रोत्साहन'),
    collapsedSummary: Bi('Recruitment of Urdu teachers and learning resources.', 'उर्दू शिक्षकांची भरती व शिक्षण साहित्य.'),
    detail: Bi(
      'States are encouraged to appoint sufficient Urdu-language teachers and make Urdu-medium textbooks and resources available where there is demand.',
      'मागणीनुसार राज्यांना पुरेसे उर्दू शिक्षक नेमण्यास व उर्दू माध्यमाची पाठ्यपुस्तके उपलब्ध करून देण्यास प्रोत्साहित केले जाते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Modernisation of Madrasa Education', 'मदरसा शिक्षणाचे आधुनिकीकरण'),
    collapsedSummary: Bi('Support to introduce modern subjects in madrasas.', 'मदरशांमध्ये आधुनिक विषय सुरू करण्यास सहाय्य.'),
    detail: Bi(
      'Financial assistance is provided to madrasas willing to introduce science, mathematics, English and social studies alongside religious education.',
      'धार्मिक शिक्षणासोबत विज्ञान, गणित, इंग्रजी व सामाजिक शास्त्रे शिकवू इच्छिणाऱ्या मदरशांना आर्थिक सहाय्य दिले जाते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Scholarships for Minority Students', 'अल्पसंख्याक विद्यार्थ्यांसाठी शिष्यवृत्ती'),
    collapsedSummary: Bi('Pre-Matric, Post-Matric and Merit-cum-Means scholarships.', 'मॅट्रिकपूर्व, मॅट्रिकोत्तर व गुणवत्ता-सह-गरजाधारित शिष्यवृत्ती.'),
    detail: Bi(
      'A structured scholarship framework supports minority students from school through professional and technical education, reducing financial barriers to learning.',
      'शालेय ते व्यावसायिक व तांत्रिक शिक्षणापर्यंत संरचित शिष्यवृत्ती चौकट अल्पसंख्याक विद्यार्थ्यांना आर्थिक अडथळे कमी करण्यास मदत करते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Strengthening Maulana Azad Education Foundation', 'मौलाना आझाद शिक्षण प्रतिष्ठानचे बळकटीकरण'),
    collapsedSummary: Bi('Expanding grants for educational infrastructure.', 'शैक्षणिक पायाभूत सुविधांसाठी अनुदान विस्तार.'),
    detail: Bi(
      "The Foundation's corpus and outreach are strengthened to fund school buildings, hostels and other educational infrastructure for minority communities.",
      'प्रतिष्ठानचा निधी व व्याप्ती वाढवून शाळा इमारती, वसतिगृहे व इतर शैक्षणिक पायाभूत सुविधांना निधी दिला जातो.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Equal Participation in Employment and Self Employment', 'रोजगार व स्वयंरोजगारात समान सहभाग'),
    collapsedSummary: Bi('Skill-linked employment and business support.', 'कौशल्याधारित रोजगार व व्यवसाय सहाय्य.'),
    detail: Bi(
      'Programmes promote fair access to jobs and encourage self-employment through training, mentorship and easier access to government job information.',
      'प्रशिक्षण, मार्गदर्शन आणि शासकीय नोकरीच्या माहितीच्या सुलभ प्रवेशाद्वारे रोजगार व स्वयंरोजगारास प्रोत्साहन दिले जाते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Skill Development and Vocational Training', 'कौशल्य विकास व व्यावसायिक प्रशिक्षण'),
    collapsedSummary: Bi('Trade-based training for youth employability.', 'युवकांच्या रोजगारक्षमतेसाठी व्यवसायाधारित प्रशिक्षण.'),
    detail: Bi(
      'Vocational training centres offer industry-relevant skill courses to improve employability and support placement of minority youth.',
      'व्यावसायिक प्रशिक्षण केंद्रे उद्योगाशी सुसंगत कौशल्य अभ्यासक्रम देऊन अल्पसंख्याक युवकांची रोजगारक्षमता व नियुक्ती सुधारतात.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Access to Credit and Financial Inclusion', 'पतपुरवठा व आर्थिक समावेशन'),
    collapsedSummary: Bi('Concessional loans via National Minorities Development Corporation.', 'राष्ट्रीय अल्पसंख्याक विकास महामंडळामार्फत सवलतीचे कर्ज.'),
    detail: Bi(
      'Concessional credit, micro-financing and financial literacy support help minority entrepreneurs and families access banking and credit facilities.',
      'सवलतीचे कर्ज, सूक्ष्म-वित्तपुरवठा व आर्थिक साक्षरता सहाय्य अल्पसंख्याक उद्योजक व कुटुंबांना बँकिंग व कर्ज सुविधांपर्यंत पोहोचण्यास मदत करते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Fair Representation in Government Employment', 'शासकीय नोकऱ्यांमध्ये न्याय्य प्रतिनिधित्व'),
    collapsedSummary: Bi('Encouraging representation in police and public services.', 'पोलीस व सार्वजनिक सेवांमध्ये प्रतिनिधित्वास प्रोत्साहन.'),
    detail: Bi(
      'States are encouraged to ensure fair representation of minorities in recruitment to state police forces and other public services.',
      'राज्य पोलीस दल व इतर सार्वजनिक सेवांच्या भरतीत अल्पसंख्याकांना न्याय्य प्रतिनिधित्व मिळावे यासाठी राज्यांना प्रोत्साहित केले जाते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Equal Share in Rural Housing Schemes', 'ग्रामीण गृहनिर्माण योजनांमध्ये समान वाटा'),
    collapsedSummary: Bi('Fair allocation under rural housing programmes.', 'ग्रामीण गृहनिर्माण कार्यक्रमांतर्गत न्याय्य वाटप.'),
    detail: Bi(
      'Minority households are ensured a fair and proportionate share of benefits under rural housing schemes such as Pradhan Mantri Awaas Yojana - Gramin.',
      'प्रधानमंत्री आवास योजना - ग्रामीण सारख्या ग्रामीण गृहनिर्माण योजनांतर्गत अल्पसंख्याक कुटुंबांना न्याय्य व प्रमाणबद्ध लाभ सुनिश्चित केला जातो.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Improvement of Living Conditions in Minority Areas', 'अल्पसंख्याकबहुल भागातील राहणीमान सुधारणा'),
    collapsedSummary: Bi('Basic amenities under the Multi-sectoral Development Programme.', 'बहुक्षेत्रीय विकास कार्यक्रमांतर्गत मूलभूत सुविधा.'),
    detail: Bi(
      'Minority Concentration Areas receive focused infrastructure investment covering drinking water, roads, healthcare and sanitation facilities.',
      'अल्पसंख्याक बहुल क्षेत्रांना पिण्याचे पाणी, रस्ते, आरोग्यसेवा व स्वच्छता सुविधांसह केंद्रित पायाभूत सुविधा गुंतवणूक मिळते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Preventing Communal Violence', 'जातीय हिंसाचार रोखणे'),
    collapsedSummary: Bi('Preventive measures in communally sensitive areas.', 'संवेदनशील भागात प्रतिबंधात्मक उपाययोजना.'),
    detail: Bi(
      'District administrations identify communally sensitive areas and take preventive measures, including deployment of additional forces during tension.',
      'जिल्हा प्रशासन जातीयदृष्ट्या संवेदनशील भाग ओळखून तणावाच्या काळात अतिरिक्त दलांच्या तैनातीसह प्रतिबंधात्मक उपाययोजना करते.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Speedy Justice in Communal Violence Cases', 'जातीय हिंसाचार प्रकरणांत जलद न्याय'),
    collapsedSummary: Bi('Fast-track courts for timely trials.', 'वेळेवर सुनावणीसाठी जलदगती न्यायालये.'),
    detail: Bi(
      'Cases relating to communal violence are prioritised for prompt investigation and trial, including through fast-track courts where required.',
      'जातीय हिंसाचाराशी संबंधित प्रकरणांना तातडीने तपास व खटला चालवण्यास प्राधान्य दिले जाते, आवश्यक तेथे जलदगती न्यायालयांद्वारे.',
    ),
  ),
  PmSchemePoint(
    title: Bi('Rehabilitation of Victims of Communal Violence', 'जातीय हिंसाचार पीडितांचे पुनर्वसन'),
    collapsedSummary: Bi('Relief, compensation and resettlement support.', 'मदत, नुकसानभरपाई व पुनर्वसन सहाय्य.'),
    detail: Bi(
      'Victims of communal violence receive financial relief, compensation and support for resettlement and rebuilding of livelihoods.',
      'जातीय हिंसाचाराच्या पीडितांना आर्थिक मदत, नुकसानभरपाई आणि पुनर्वसन व उपजीविका पुनर्बांधणीसाठी सहाय्य दिले जाते.',
    ),
  ),
];
