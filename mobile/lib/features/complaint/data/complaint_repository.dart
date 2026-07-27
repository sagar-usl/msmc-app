import '../../../core/network/api_client.dart';
import 'complaint_api_models.dart';

class ComplaintRepository {
  const ComplaintRepository();

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
  }) async {
    final data = await ApiClient.instance.post<Map<String, dynamic>>(
      '/api/v1/complaints',
      data: {
        'fullName': fullName,
        'mobile': mobile,
        'category': category,
        'description': description,
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
