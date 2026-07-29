import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around Firebase Phone Auth. Indian numbers only (the app is
/// India-specific), so the +91 country code is applied here rather than
/// asked for in the UI.
class PhoneOtpService {
  PhoneOtpService._();
  static final PhoneOtpService instance = PhoneOtpService._();

  /// How long to wait for Firebase to respond at all before giving up.
  /// Separate from the `timeout` passed to verifyPhoneNumber, which only
  /// governs Android's post-send SMS auto-retrieval window — it does
  /// nothing to bound the initial network/device-verification step, which
  /// can hang indefinitely on emulators without Play Store/Play Integrity.
  static const _requestTimeout = Duration(seconds: 20);

  /// Starts phone verification for [mobile] (10 digits, no country code).
  ///
  /// [onCodeSent] fires once Firebase has dispatched the SMS — the caller
  /// should show a code-entry UI at that point. [onAutoVerified] fires if
  /// Android's silent SMS auto-retrieval completes verification before the
  /// user types anything (common on real devices; rarely on emulators).
  /// [onFailed] carries a message already mapped to something displayable —
  /// including if nothing at all comes back within [_requestTimeout].
  Future<void> sendOtp({
    required String mobile,
    required void Function(String verificationId) onCodeSent,
    required void Function() onAutoVerified,
    required void Function(String message) onFailed,
  }) async {
    var settled = false;
    void settle(void Function() action) {
      if (settled) return;
      settled = true;
      action();
    }

    final timeoutTimer = Timer(_requestTimeout, () {
      settle(() => onFailed(
            'No response from Firebase. On an emulator without Play Store, phone '
            'verification often can\'t complete — try a "Google Play" emulator image '
            'or a real device, and make sure this number is added as a test number in '
            'Firebase Console.',
          ));
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$mobile',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        timeoutTimer.cancel();
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          settle(onAutoVerified);
        } catch (_) {
          settle(() => onFailed('Automatic verification failed — please enter the code manually.'));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        timeoutTimer.cancel();
        settle(() => onFailed(_mapError(e)));
      },
      codeSent: (String verificationId, int? resendToken) {
        timeoutTimer.cancel();
        settle(() => onCodeSent(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// Verifies the code the citizen typed in. Returns true on success.
  Future<bool> verifyCode({required String verificationId, required String smsCode}) async {
    try {
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (_) {
      return false;
    }
  }

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'That doesn\'t look like a valid phone number.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Could not send OTP. Please try again.';
    }
  }
}
