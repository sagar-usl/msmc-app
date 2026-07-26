import '../../../core/localization/bi.dart';

const List<Bi> kAboutFunctions = [
  Bi('Objectives', 'उद्दिष्टे'),
  Bi('Functions & Powers', 'कार्ये व अधिकार'),
  Bi('Organisational Structure', 'संघटनात्मक रचना'),
  Bi('Annual Report', 'वार्षिक अहवाल'),
];

class CommissionMember {
  final Bi name;
  final Bi designation;
  final String initials;
  const CommissionMember({required this.name, required this.designation, required this.initials});
}

const List<CommissionMember> kLeadership = [
  CommissionMember(name: Bi('Shri. Pyare Jiya Khan', 'श्री. प्यारे जिया खान'), designation: Bi('Chairman', 'अध्यक्ष'), initials: 'PK'),
  CommissionMember(name: Bi('Shri. Chetan Kheraj Dedhia', 'श्री. चेतन खेराज देधिया'), designation: Bi('Vice Chairman', 'उपाध्यक्ष'), initials: 'CD'),
];

const List<CommissionMember> kMembers = [
  CommissionMember(name: Bi('Shri. Lalit Gandhi', 'श्री. ललित गांधी'), designation: Bi('Member', 'सदस्य'), initials: 'LG'),
  CommissionMember(name: Bi('Shri. Charandeep Singh (Happy Singh)', 'श्री. चरणदीप सिंग (हॅपी सिंग)'), designation: Bi('Member', 'सदस्य'), initials: 'CS'),
  CommissionMember(name: Bi('Shri. Ahmed Sharif Abdul Bashid Deshmukh', 'श्री. अहमद शरीफ अब्दुल बशीद देशमुख'), designation: Bi('Member', 'सदस्य'), initials: 'AD'),
  CommissionMember(name: Bi('Shri. Shaikh Washim', 'श्री. शेख वसीम'), designation: Bi('Member', 'सदस्य'), initials: 'SW'),
  CommissionMember(name: Bi('Shri. Shaikh Gulam Rasool Gulam Hussain', 'श्री. शेख गुलाम रसूल गुलाम हुसेन'), designation: Bi('Member', 'सदस्य'), initials: 'SG'),
  CommissionMember(name: Bi('Shri. Sanjay Lalchandji Surana', 'श्री. संजय लालचंदजी सुराणा'), designation: Bi('Member', 'सदस्य'), initials: 'SS'),
  CommissionMember(name: Bi('Shri. Afasar Shaikh', 'श्री. अफसर शेख'), designation: Bi('Member', 'सदस्य'), initials: 'AS'),
  CommissionMember(name: Bi('Shri. Wasim Khwaja Bhai Burhan', 'श्री. वसीम ख्वाजा भाई बुरहान'), designation: Bi('Member', 'सदस्य'), initials: 'WB'),
  CommissionMember(name: Bi('Shri. Hussain Babulal Shaikh', 'श्री. हुसेन बाबुलाल शेख'), designation: Bi('Member', 'सदस्य'), initials: 'HS'),
];

class HierarchyNode {
  final Bi label;
  final bool saffron;
  const HierarchyNode({required this.label, this.saffron = false});
}

class HierarchyLevel {
  final List<HierarchyNode> nodes;
  const HierarchyLevel(this.nodes);
}

const List<HierarchyLevel> kHierarchy = [
  HierarchyLevel([HierarchyNode(label: Bi('Chairman', 'अध्यक्ष'), saffron: true)]),
  HierarchyLevel([HierarchyNode(label: Bi('Vice Chairman', 'उपाध्यक्ष'), saffron: true)]),
  HierarchyLevel([HierarchyNode(label: Bi('Members', 'सदस्य'))]),
  HierarchyLevel([HierarchyNode(label: Bi('Secretary', 'सचिव'))]),
  HierarchyLevel([
    HierarchyNode(label: Bi('Asst. Accounting Officer', 'सहायक लेखा अधिकारी')),
    HierarchyNode(label: Bi('Stenographer', 'लघुलेखक')),
    HierarchyNode(label: Bi('Assistant', 'सहायक')),
    HierarchyNode(label: Bi('Driver', 'चालक')),
  ]),
  HierarchyLevel([HierarchyNode(label: Bi('Clerical Typists', 'लिपिक टंकलेखक'))]),
  HierarchyLevel([HierarchyNode(label: Bi('Peons', 'शिपाई'))]),
];
