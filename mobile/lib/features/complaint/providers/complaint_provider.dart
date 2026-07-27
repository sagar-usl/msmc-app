import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/complaint_api_models.dart';
import '../data/complaint_repository.dart';

final _repo = const ComplaintRepository();

/// Provider that exposes the current citizen's mobile (null = not onboarded yet).
final citizenMobileProvider = FutureProvider<String?>((ref) => SecureStorage.instance.getMobile());

/// Provider that exposes the current citizen's saved name (null = not onboarded yet).
final citizenNameProvider = FutureProvider<String?>((ref) => SecureStorage.instance.getName());

/// Complaint list — loaded once the mobile is known.
final complaintListProvider =
    AsyncNotifierProvider<ComplaintListNotifier, List<ComplaintSummary>>(ComplaintListNotifier.new);

class ComplaintListNotifier extends AsyncNotifier<List<ComplaintSummary>> {
  @override
  Future<List<ComplaintSummary>> build() async {
    final mobile = await SecureStorage.instance.getMobile();
    if (mobile == null) return [];
    return _repo.fetchMyComplaints(mobile);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final mobile = await SecureStorage.instance.getMobile();
      if (mobile == null) return <ComplaintSummary>[];
      return _repo.fetchMyComplaints(mobile);
    });
  }

  /// Submit a complaint and refresh the list. Returns the new ticketId.
  Future<String> submit({
    required String fullName,
    required String mobile,
    required String category,
    required String description,
    List<UploadedAttachment> attachments = const [],
  }) async {
    final ticketId = await _repo.submitComplaint(
      fullName: fullName,
      mobile: mobile,
      category: category,
      description: description,
      attachments: attachments,
    );
    await refresh();
    return ticketId;
  }
}

/// Per-complaint detail provider (family keyed by ticketId).
final complaintDetailProvider =
    AsyncNotifierProvider.family<ComplaintDetailNotifier, ComplaintDetail, String>(
  ComplaintDetailNotifier.new,
);

class ComplaintDetailNotifier extends AsyncNotifier<ComplaintDetail> {
  ComplaintDetailNotifier(this.ticketId);
  final String ticketId;

  Future<ComplaintDetail> _fetch() async {
    final mobile = await SecureStorage.instance.getMobile();
    if (mobile == null) throw Exception('Not logged in');
    return _repo.fetchDetail(ticketId: ticketId, mobile: mobile);
  }

  @override
  Future<ComplaintDetail> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}
