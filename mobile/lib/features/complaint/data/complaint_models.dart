import '../../../core/localization/bi.dart';

enum ComplaintCategory { documents, education, schemeDelay, corruption, other }

enum ComplaintStatus { underReview, accepted, rejected, caseOnboard, finalHearingScheduled, disposedOf }

class Hearing {
  final String date; // ISO yyyy-MM-dd
  final String time; // HH:mm
  final Bi location;
  final Bi officer;

  const Hearing({required this.date, required this.time, required this.location, required this.officer});
}

class Complaint {
  final String id; // ticket id, e.g. CMP/2026/000131
  final Bi name;
  final String mobile;
  final ComplaintCategory category;
  final Bi description;
  final String fileName;
  final Bi date;
  final ComplaintStatus status;
  final Bi? rejectionReason;
  final Hearing? hearing;
  final Hearing? hearing2;
  final String? verdictFile;

  const Complaint({
    required this.id,
    required this.name,
    required this.mobile,
    required this.category,
    required this.description,
    required this.fileName,
    required this.date,
    required this.status,
    this.rejectionReason,
    this.hearing,
    this.hearing2,
    this.verdictFile,
  });

  Complaint copyWith({
    ComplaintStatus? status,
    Bi? rejectionReason,
    Hearing? hearing,
    Hearing? hearing2,
    String? verdictFile,
  }) {
    return Complaint(
      id: id,
      name: name,
      mobile: mobile,
      category: category,
      description: description,
      fileName: fileName,
      date: date,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      hearing: hearing ?? this.hearing,
      hearing2: hearing2 ?? this.hearing2,
      verdictFile: verdictFile ?? this.verdictFile,
    );
  }
}
