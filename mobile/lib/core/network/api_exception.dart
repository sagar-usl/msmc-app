/// Typed exception thrown by [ApiClient] for all non-2xx responses
/// and network-level failures.
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final bool isNetworkError;

  const ApiException({
    this.statusCode,
    required this.message,
    this.isNetworkError = false,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';

  /// Human-readable message suitable for showing to citizens.
  String get userMessage {
    if (isNetworkError) return 'No internet connection. Please check your network and try again.';
    return switch (statusCode) {
      400 => 'Please check your input and try again.',
      403 => 'You do not have permission to perform this action.',
      404 => 'The requested information was not found.',
      429 => 'Too many requests. Please wait a moment and try again.',
      int code when code >= 500 => 'Server error. Please try again later.',
      _ => message,
    };
  }
}
