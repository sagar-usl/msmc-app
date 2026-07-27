import '../../../core/network/api_client.dart';

// ignore_for_file: constant_identifier_names
// Enum values mirror the server's DocumentCategory wire strings exactly
// (see ApiDocCategoryExt.fromString), so they intentionally stay SCREAMING_CASE.
enum ApiDocCategory { REPORTS, ACTS, POLICIES }

extension ApiDocCategoryExt on ApiDocCategory {
  static ApiDocCategory fromString(String s) =>
    ApiDocCategory.values.firstWhere((e) => e.name == s, orElse: () => ApiDocCategory.REPORTS);
}

class DocumentApiItem {
  final String id;
  final String titleEn;
  final String titleMr;
  final String? metaEn;
  final String? metaMr;
  final ApiDocCategory category;
  final String? filePath;

  const DocumentApiItem({
    required this.id,
    required this.titleEn,
    required this.titleMr,
    this.metaEn,
    this.metaMr,
    required this.category,
    this.filePath,
  });

  factory DocumentApiItem.fromJson(Map<String, dynamic> j) => DocumentApiItem(
    id: j['id'] as String,
    titleEn: j['titleEn'] as String,
    titleMr: j['titleMr'] as String,
    metaEn: j['metaEn'] as String?,
    metaMr: j['metaMr'] as String?,
    category: ApiDocCategoryExt.fromString(j['category'] as String),
    filePath: j['filePath'] as String?,
  );

  String title(String lang) => lang == 'mr' ? titleMr : titleEn;
  String? meta(String lang) => lang == 'mr' ? metaMr : metaEn;
}

class DocumentsRepository {
  const DocumentsRepository();

  Future<List<DocumentApiItem>> fetchDocuments() async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>('/api/v1/content/documents');
    final list = data['items'] as List<dynamic>;
    return list.map((e) => DocumentApiItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
