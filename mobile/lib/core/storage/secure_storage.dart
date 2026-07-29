import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps flutter_secure_storage for citizen session persistence.
///
/// We store the citizen's name, mobile number (the "identity"), and which
/// mobile number has actually passed OTP verification. Mobile number acts
/// as the identifier when fetching complaints — there is no separate JWT
/// beyond the Firebase phone-auth credential itself.
class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _keyMobile         = 'citizen_mobile';
  static const _keyName           = 'citizen_name';
  static const _keyVerifiedMobile = 'verified_mobile';

  Future<void> saveCitizen({required String mobile, required String name}) async {
    await _storage.write(key: _keyMobile, value: mobile);
    await _storage.write(key: _keyName,   value: name);
  }

  Future<String?> getMobile() => _storage.read(key: _keyMobile);
  Future<String?> getName()   => _storage.read(key: _keyName);

  /// Records that [mobile] has just passed OTP verification.
  Future<void> saveVerifiedMobile(String mobile) => _storage.write(key: _keyVerifiedMobile, value: mobile);

  /// Whether [mobile] has already passed OTP verification on this device —
  /// used to avoid re-verifying every time the same number is used again
  /// (e.g. filing a second complaint).
  Future<bool> isMobileVerified(String mobile) async {
    final verified = await _storage.read(key: _keyVerifiedMobile);
    return verified == mobile;
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyMobile);
    await _storage.delete(key: _keyName);
    await _storage.delete(key: _keyVerifiedMobile);
  }
}
