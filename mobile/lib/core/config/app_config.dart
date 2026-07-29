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

  /// Testing-only bypass letting a citizen skip real phone verification by
  /// picking "Demo Login" and entering the fixed code below — added so this
  /// build can be tested widely before Firebase Blaze billing (required for
  /// real SMS) is set up on every tester's number.
  ///
  /// MUST be false before the Play Store release: flip the default here, or
  /// override per-build without touching code via
  ///   flutter build apk --dart-define=DEMO_LOGIN_ENABLED=false
  static const bool demoLoginEnabled = bool.fromEnvironment(
    'DEMO_LOGIN_ENABLED',
    defaultValue: true,
  );
  static const String demoOtpCode = '123456';
}
