import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/documents_repository.dart';

final _repo = const DocumentsRepository();

final documentsProvider = AsyncNotifierProvider<DocumentsNotifier, List<DocumentApiItem>>(DocumentsNotifier.new);

class DocumentsNotifier extends AsyncNotifier<List<DocumentApiItem>> {
  @override
  Future<List<DocumentApiItem>> build() => _repo.fetchDocuments();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchDocuments());
  }
}
