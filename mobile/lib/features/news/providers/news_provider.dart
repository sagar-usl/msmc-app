import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/news_repository.dart';

final _repo = const NewsRepository();

final newsProvider = AsyncNotifierProvider<NewsNotifier, List<NewsApiItem>>(NewsNotifier.new);

class NewsNotifier extends AsyncNotifier<List<NewsApiItem>> {
  @override
  Future<List<NewsApiItem>> build() => _repo.fetchNews();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchNews());
  }
}
