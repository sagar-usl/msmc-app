import 'package:flutter_riverpod/legacy.dart';
import '../../../core/localization/bi.dart';
import '../data/complaint_models.dart';
import '../data/complaint_seed.dart';

/// Citizen-vs-officer view toggle. In the real backend (Phase 4 of the build
/// plan) this becomes a real `role` claim on the JWT gated by
/// `requireRole('officer')`; for now it's a local dev switch so the same
/// screen can be exercised both ways, mirroring what the prototype fakes
/// entirely client-side.
final isOfficerModeProvider = StateProvider<bool>((ref) => false);

final complaintListProvider = StateNotifierProvider<ComplaintNotifier, List<Complaint>>((ref) {
  return ComplaintNotifier();
});

class ComplaintNotifier extends StateNotifier<List<Complaint>> {
  ComplaintNotifier() : super(seedComplaints());

  String _generateTicketId() {
    final n = 100000 + DateTime.now().microsecondsSinceEpoch % 899999;
    return 'CMP/2026/$n';
  }

  /// Returns the new ticket id.
  String submit({
    required String name,
    required String mobile,
    required ComplaintCategory category,
    required String description,
    String? fileName,
  }) {
    final id = _generateTicketId();
    final complaint = Complaint(
      id: id,
      name: Bi(name, name),
      mobile: mobile,
      category: category,
      description: Bi(description, description),
      fileName: fileName ?? '',
      date: const Bi('Today', 'आज'),
      status: ComplaintStatus.underReview,
    );
    state = [complaint, ...state];
    return id;
  }

  void _update(String id, Complaint Function(Complaint) update) {
    state = [
      for (final c in state)
        if (c.id == id) update(c) else c,
    ];
  }

  void accept(String id) => _update(id, (c) => c.copyWith(status: ComplaintStatus.accepted));

  void reject(String id, String reason) => _update(
        id,
        (c) => c.copyWith(status: ComplaintStatus.rejected, rejectionReason: Bi(reason, reason)),
      );

  void saveHearing(String id, {required String date, required String time, required String location, required String officer}) {
    _update(
      id,
      (c) => c.copyWith(
        status: ComplaintStatus.caseOnboard,
        hearing: Hearing(date: date, time: time, location: Bi(location, location), officer: Bi(officer, officer)),
      ),
    );
  }

  void saveHearing2(String id, {required String date, required String time, required String location, required String officer}) {
    _update(
      id,
      (c) => c.copyWith(
        status: ComplaintStatus.finalHearingScheduled,
        hearing2: Hearing(date: date, time: time, location: Bi(location, location), officer: Bi(officer, officer)),
      ),
    );
  }

  void uploadVerdict(String id, String fileName) {
    _update(id, (c) => c.copyWith(status: ComplaintStatus.disposedOf, verdictFile: fileName));
  }
}
