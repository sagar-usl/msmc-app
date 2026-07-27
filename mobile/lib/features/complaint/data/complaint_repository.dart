import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'complaint_api_models.dart';

/// Reference to an already-uploaded file, returned by [ComplaintRepository.uploadAttachment]
/// and passed to [ComplaintRepository.submitComplaint].
class UploadedAttachment {
  final String fileName;
  final String filePath;
  const UploadedAttachment({required this.fileName, required this.filePath});
}

class ComplaintRepository {
  const ComplaintRepository();

  /// Uploads one supporting document (image or PDF) ahead of complaint
  /// submission. Call once per picked file, then pass the results to
  /// [submitComplaint].
  Future<UploadedAttachment> uploadAttachment(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
    });
    final data = await ApiClient.instance.post<Map<String, dynamic>>(
      '/api/v1/uploads/complaint-attachment',
      data: formData,
    );
    return UploadedAttachment(
      fileName: data['fileName'] as String,
      filePath: data['filePath'] as String,
    );
  }

  /// Fetch all complaints for this citizen by mobile number.
  Future<List<ComplaintSummary>> fetchMyComplaints(String mobile) async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>(
      '/api/v1/complaints',
      queryParameters: {'mobile': mobile},
    );
    final list = data['complaints'] as List<dynamic>;
    return list.map((e) => ComplaintSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Submit a new complaint. Returns the generated ticketId.
  Future<String> submitComplaint({
    required String fullName,
    required String mobile,
    required String category,
    required String description,
    List<UploadedAttachment> attachments = const [],
  }) async {
    final data = await ApiClient.instance.post<Map<String, dynamic>>(
      '/api/v1/complaints',
      data: {
        'fullName': fullName,
        'mobile': mobile,
        'category': category,
        'description': description,
        'attachments': attachments
            .map((a) => {'fileName': a.fileName, 'filePath': a.filePath})
            .toList(),
      },
    );
    return data['ticketId'] as String;
  }

  /// Fetch full detail for a single complaint (citizen read-only view).
  Future<ComplaintDetail> fetchDetail({
    required String ticketId,
    required String mobile,
  }) async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>(
      '/api/v1/complaints/${Uri.encodeComponent(ticketId)}',
      queryParameters: {'mobile': mobile},
    );
    return ComplaintDetail.fromJson(data['complaint'] as Map<String, dynamic>);
  }
}
