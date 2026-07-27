import '../../../core/network/api_client.dart';

class EducationApiItem {
  final String id;
  final String titleEn;
  final String titleMr;
  final String? descEn;
  final String? descMr;

  const EducationApiItem({
    required this.id,
    required this.titleEn,
    required this.titleMr,
    this.descEn,
    this.descMr,
  });

  factory EducationApiItem.fromJson(Map<String, dynamic> j) => EducationApiItem(
    id: j['id'] as String,
    titleEn: j['titleEn'] as String,
    titleMr: j['titleMr'] as String,
    descEn: j['descEn'] as String?,
    descMr: j['descMr'] as String?,
  );

  String title(String lang) => lang == 'mr' ? titleMr : titleEn;
  String desc(String lang) => lang == 'mr' ? (descMr ?? '') : (descEn ?? '');
}

class EducationRepository {
  const EducationRepository();

  Future<List<EducationApiItem>> fetchItems() async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>('/api/v1/content/education');
    final list = data['items'] as List<dynamic>;
    return list.map((e) => EducationApiItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
