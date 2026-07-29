import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';

/// Provider that exposes the current citizen's mobile (null = not onboarded yet).
final citizenMobileProvider = FutureProvider<String?>((ref) => SecureStorage.instance.getMobile());

/// Provider that exposes the current citizen's saved name (null = not onboarded yet).
final citizenNameProvider = FutureProvider<String?>((ref) => SecureStorage.instance.getName());

/// Whether the citizen has a mobile number saved AND that exact number has
/// passed OTP verification. This — not just "a mobile is saved" — is what
/// gates complaint filing, feedback, and anything else that needs a real,
/// verified identity: a mobile saved before OTP verification existed (or
/// never re-verified) should not count as logged in.
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final mobile = await SecureStorage.instance.getMobile();
  if (mobile == null || mobile.isEmpty) return false;
  return SecureStorage.instance.isMobileVerified(mobile);
});
