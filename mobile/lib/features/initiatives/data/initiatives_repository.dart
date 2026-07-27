import '../../../core/network/api_client.dart';

class InitiativeApiItem {
  final String id;
  final String titleEn;
  final String titleMr;
  final String districtEn;
  final String districtMr;
  final String? descriptionEn;
  final String? descriptionMr;
  /// Relative URL like /api/v1/uploads/initiative-image/xxx.jpg, or null.
  final String? imagePath;

  const InitiativeApiItem({
    required this.id,
    required this.titleEn,
    required this.titleMr,
    required this.districtEn,
    required this.districtMr,
    this.descriptionEn,
    this.descriptionMr,
    this.imagePath,
  });

  factory InitiativeApiItem.fromJson(Map<String, dynamic> j) => InitiativeApiItem(
    id: j['id'] as String,
    titleEn: j['titleEn'] as String,
    titleMr: j['titleMr'] as String,
    districtEn: j['districtEn'] as String,
    districtMr: j['districtMr'] as String,
    descriptionEn: j['descriptionEn'] as String?,
    descriptionMr: j['descriptionMr'] as String?,
    imagePath: j['imagePath'] as String?,
  );

  String title(String lang) => lang == 'mr' ? titleMr : titleEn;
  String district(String lang) => lang == 'mr' ? districtMr : districtEn;
  String description(String lang) => lang == 'mr' ? (descriptionMr ?? '') : (descriptionEn ?? '');

  /// Absolute image URL built from the API client's base URL.
  String? imageUrl() {
    if (imagePath == null) return null;
    return ApiClient.instance.absoluteUrl(imagePath!);
  }
}

class InitiativesRepository {
  const InitiativesRepository();

  Future<List<InitiativeApiItem>> fetchInitiatives() async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>('/api/v1/content/initiatives');
    final list = data['items'] as List<dynamic>;
    return list.map((e) => InitiativeApiItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
