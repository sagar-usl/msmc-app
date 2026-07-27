import '../../../core/network/api_client.dart';

class NewsApiItem {
  final String id;
  final String tag;          // SCHEME_UPDATE | NOTICE | EVENT
  final String publishedDate; // yyyy-MM-dd
  final String titleEn;
  final String titleMr;
  final String? snippetEn;
  final String? snippetMr;

  const NewsApiItem({
    required this.id,
    required this.tag,
    required this.publishedDate,
    required this.titleEn,
    required this.titleMr,
    this.snippetEn,
    this.snippetMr,
  });

  factory NewsApiItem.fromJson(Map<String, dynamic> j) => NewsApiItem(
    id: j['id'] as String,
    tag: j['tag'] as String,
    publishedDate: j['publishedDate'] as String,
    titleEn: j['titleEn'] as String,
    titleMr: j['titleMr'] as String,
    snippetEn: j['snippetEn'] as String?,
    snippetMr: j['snippetMr'] as String?,
  );

  String title(String lang) => lang == 'mr' ? titleMr : titleEn;
  String? snippet(String lang) => lang == 'mr' ? snippetMr : snippetEn;
}

class NewsRepository {
  const NewsRepository();

  Future<List<NewsApiItem>> fetchNews() async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>('/api/v1/content/news');
    final list = data['items'] as List<dynamic>;
    return list.map((e) => NewsApiItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
