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
  final bool isFinal;

  const HearingInfo({
    required this.date,
    required this.time,
    required this.location,
    required this.officer,
    required this.isFinal,
  });

  factory HearingInfo.fromJson(Map<String, dynamic> j) => HearingInfo(
    date:     j['date'] as String,
    time:     j['time'] as String,
    location: j['location'] as String,
    officer:  j['officer'] as String,
    isFinal:  j['isFinal'] as bool,
  );
}

class ComplaintAttachmentInfo {
  final String fileName;
  final String fileUrl;

  const ComplaintAttachmentInfo({required this.fileName, required this.fileUrl});

  factory ComplaintAttachmentInfo.fromJson(Map<String, dynamic> j) => ComplaintAttachmentInfo(
    fileName: j['fileName'] as String,
    fileUrl:  j['fileUrl'] as String,
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
  final String? dismissalReason;
  final List<HearingInfo> hearings;
  final List<ComplaintAttachmentInfo> documents;
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
    this.dismissalReason,
    required this.hearings,
    required this.documents,
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
    dismissalReason:  j['dismissalReason'] as String?,
    hearings: (j['hearings'] as List<dynamic>)
        .map((h) => HearingInfo.fromJson(h as Map<String, dynamic>))
        .toList(),
    documents: (j['documents'] as List<dynamic>)
        .map((d) => ComplaintAttachmentInfo.fromJson(d as Map<String, dynamic>))
        .toList(),
    verdictDownloadUrl: j['verdictDownloadUrl'] as String?,
  );
}
