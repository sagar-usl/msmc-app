/// Compile-time configuration injected via --dart-define.
///
/// Usage (dev):
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
///
/// Usage (staging / prod):
///   flutter build apk --dart-define=API_BASE_URL=https://your-domain.com
///
/// The default 10.0.2.2 is the Android emulator's alias for the host machine's
/// localhost. For a physical device on the same Wi-Fi, replace with the host IP.
class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
}
