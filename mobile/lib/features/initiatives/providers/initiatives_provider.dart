import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/initiatives_repository.dart';

final _repo = const InitiativesRepository();

final initiativesProvider = AsyncNotifierProvider<InitiativesNotifier, List<InitiativeApiItem>>(InitiativesNotifier.new);

class InitiativesNotifier extends AsyncNotifier<List<InitiativeApiItem>> {
  @override
  Future<List<InitiativeApiItem>> build() => _repo.fetchInitiatives();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchInitiatives());
  }
}
