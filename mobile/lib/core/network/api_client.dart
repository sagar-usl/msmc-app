import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'api_exception.dart';

/// Singleton Dio client configured for the MSMC API.
///
/// All API calls throw [ApiException] on failure — never raw DioException —
/// so call sites only need to catch one exception type.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio _dio = _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Log in debug builds only.
    assert(() {
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
      return true;
    }());

    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException err, ErrorInterceptorHandler handler) {
        throw _mapError(err);
      },
    ));

    return dio;
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dio.get<T>(path, queryParameters: queryParameters);
      return res.data as T;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), isNetworkError: true);
    }
  }

  Future<T> post<T>(String path, {Object? data}) async {
    try {
      final res = await _dio.post<T>(path, data: data);
      return res.data as T;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), isNetworkError: true);
    }
  }

  /// Returns a full download URL using the base URL.
  String absoluteUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;
    return '$base$path';
  }

  ApiException _mapError(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      return const ApiException(message: 'Network error', isNetworkError: true);
    }
    final statusCode = err.response?.statusCode;
    final dynamic body = err.response?.data;
    final message = (body is Map && body['error'] is String)
        ? body['error'] as String
        : err.message ?? 'Unknown error';
    return ApiException(statusCode: statusCode, message: message);
  }
}
