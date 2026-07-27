import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps flutter_secure_storage for citizen session persistence.
///
/// We store only the citizen's name and mobile number (the "identity").
/// There is no JWT yet — mobile number acts as the identifier when
/// fetching complaints. OTP auth can be layered on top later without
/// changing the storage contract.
class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _keyMobile = 'citizen_mobile';
  static const _keyName   = 'citizen_name';

  Future<void> saveCitizen({required String mobile, required String name}) async {
    await _storage.write(key: _keyMobile, value: mobile);
    await _storage.write(key: _keyName,   value: name);
  }

  Future<String?> getMobile() => _storage.read(key: _keyMobile);
  Future<String?> getName()   => _storage.read(key: _keyName);

  Future<void> clear() async {
    await _storage.delete(key: _keyMobile);
    await _storage.delete(key: _keyName);
  }
}
