// JSON-mapped models for the /api/v1/complaints endpoints.

class ComplaintSummary {
  final String id;           // ticketId e.g. CMP/2026/123456
  final String status;
  final String category;
  final String submittedAt;  // yyyy-MM-dd
  final String? assignedOfficer;

  const ComplaintSummary({
    required this.id,
    required this.status,
    required this.category,
    required this.submittedAt,
    this.assignedOfficer,
  });

  factory ComplaintSummary.fromJson(Map<String, dynamic> j) => ComplaintSummary(
    id:             j['id'] as String,
    status:         j['status'] as String,
    category:       j['category'] as String,
    submittedAt:    j['submittedAt'] as String,
    assignedOfficer: j['assignedOfficer'] as String?,
  );
}

class HearingInfo {
  final String date;
  final String time;
  final String location;
  final String officer;

  const HearingInfo({
    required this.date,
    required this.time,
    required this.location,
    required this.officer,
  });

  factory HearingInfo.fromJson(Map<String, dynamic> j) => HearingInfo(
    date:     j['date'] as String,
    time:     j['time'] as String,
    location: j['location'] as String,
    officer:  j['officer'] as String,
  );
}

class ComplaintDetail {
  final String id;
  final String status;
  final String category;
  final String description;
  final String submittedAt;
  final String? assignedOfficer;
  final String? rejectionReason;
  final HearingInfo? hearing;
  final HearingInfo? hearing2;
  /// Pre-built download URL from the server (includes mobile + ticket query params).
  final String? verdictDownloadUrl;

  const ComplaintDetail({
    required this.id,
    required this.status,
    required this.category,
    required this.description,
    required this.submittedAt,
    this.assignedOfficer,
    this.rejectionReason,
    this.hearing,
    this.hearing2,
    this.verdictDownloadUrl,
  });

  factory ComplaintDetail.fromJson(Map<String, dynamic> j) => ComplaintDetail(
    id:               j['id'] as String,
    status:           j['status'] as String,
    category:         j['category'] as String,
    description:      j['description'] as String,
    submittedAt:      j['submittedAt'] as String,
    assignedOfficer:  j['assignedOfficer'] as String?,
    rejectionReason:  j['rejectionReason'] as String?,
    hearing:  j['hearing'] != null  ? HearingInfo.fromJson(j['hearing'] as Map<String, dynamic>)  : null,
    hearing2: j['hearing2'] != null ? HearingInfo.fromJson(j['hearing2'] as Map<String, dynamic>) : null,
    verdictDownloadUrl: j['verdictDownloadUrl'] as String?,
  );
}
