import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/education_repository.dart';

final _repo = const EducationRepository();

final educationProvider = AsyncNotifierProvider<EducationNotifier, List<EducationApiItem>>(EducationNotifier.new);

class EducationNotifier extends AsyncNotifier<List<EducationApiItem>> {
  @override
  Future<List<EducationApiItem>> build() => _repo.fetchItems();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchItems());
  }
}
