import '../../../core/network/api_client.dart';

class FeedbackRepository {
  const FeedbackRepository();

  Future<void> submitFeedback({
    required int rating,
    String? name,
    required String message,
  }) async {
    await ApiClient.instance.post<Map<String, dynamic>>(
      '/api/v1/feedback',
      data: {
        'rating': rating,
        if (name != null && name.isNotEmpty) 'name': name,
        'message': message,
      },
    );
  }
}
