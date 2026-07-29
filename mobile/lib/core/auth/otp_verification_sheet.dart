import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../theme/app_colors.dart';
import '../storage/secure_storage.dart';
import 'phone_otp_service.dart';

enum _LoginMode { phoneOtp, demo }

/// Shows the OTP verification flow for [mobile] (10 digits, no country
/// code). Returns true once verified — including immediately, with no UI
/// shown at all, if this exact number was already verified earlier on this
/// device — or false if the citizen cancels or verification doesn't
/// complete.
Future<bool> verifyMobileOtp(BuildContext context, String mobile) async {
  if (await SecureStorage.instance.isMobileVerified(mobile)) return true;
  if (!context.mounted) return false;

  final verified = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) => _OtpSheet(mobile: mobile),
  );

  if (verified == true) {
    await SecureStorage.instance.saveVerifiedMobile(mobile);
    return true;
  }
  return false;
}

class _OtpSheet extends StatefulWidget {
  final String mobile;
  const _OtpSheet({required this.mobile});

  @override
  State<_OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<_OtpSheet> {
  final _codeController = TextEditingController();
  _LoginMode _mode = _LoginMode.phoneOtp;
  String? _verificationId;
  bool _isSending = true;
  bool _isVerifying = false;
  String? _error;
  Timer? _resendTimer;
  int _resendSecondsLeft = 60;

  @override
  void initState() {
    super.initState();
    _send();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _switchMode(_LoginMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      _error = null;
      _codeController.clear();
    });
    if (mode == _LoginMode.phoneOtp && _verificationId == null && !_isSending) {
      _send();
    }
  }

  Future<void> _send() async {
    setState(() {
      _isSending = true;
      _error = null;
    });
    await PhoneOtpService.instance.sendOtp(
      mobile: widget.mobile,
      onCodeSent: (verificationId) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          _isSending = false;
        });
        _startResendTimer();
      },
      onAutoVerified: () {
        if (mounted) Navigator.of(context).pop(true);
      },
      onFailed: (message) {
        if (!mounted) return;
        setState(() {
          _isSending = false;
          _error = message;
        });
      },
    );
  }

  void _startResendTimer() {
    _resendSecondsLeft = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendSecondsLeft--;
        if (_resendSecondsLeft <= 0) timer.cancel();
      });
    });
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length != 6 || _verificationId == null) return;

    setState(() {
      _isVerifying = true;
      _error = null;
    });
    final ok = await PhoneOtpService.instance.verifyCode(verificationId: _verificationId!, smsCode: code);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isVerifying = false;
        _error = 'otp.invalid'.tr();
      });
    }
  }

  /// Local-only check against the fixed demo code — no Firebase/network
  /// call at all, so it works regardless of billing or device-verification
  /// issues. Testing convenience only; see AppConfig.demoLoginEnabled.
  void _verifyDemo() {
    final code = _codeController.text.trim();
    if (code.length != 6) return;

    if (code == AppConfig.demoOtpCode) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = 'otp.invalid'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('otp.title'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          if (_mode == _LoginMode.phoneOtp)
            Text('${'otp.sentTo'.tr()} +91 ${widget.mobile}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted))
          else
            Text('Testing mode — no real SMS is sent.', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          if (AppConfig.demoLoginEnabled) ...[
            const SizedBox(height: 14),
            _buildModeToggle(),
          ],
          const SizedBox(height: 16),
          if (_mode == _LoginMode.demo) _buildDemoBody() else _buildPhoneOtpBody(),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('otp.cancel'.tr(), style: const TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: _modeTab('Phone OTP', _LoginMode.phoneOtp)),
          Expanded(child: _modeTab('Demo Login', _LoginMode.demo)),
        ],
      ),
    );
  }

  Widget _modeTab(String label, _LoginMode mode) {
    final active = _mode == mode;
    return GestureDetector(
      onTap: () => _switchMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active ? [BoxShadow(color: AppColors.navyTint(0.1), blurRadius: 4)] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: active ? AppColors.navy : AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildDemoBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.saffronTint(0.12), borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Enter the test code: ${AppConfig.demoOtpCode}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 12),
        _codeField(),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.red)),
        ],
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: _codeController.text.trim().length == 6 ? _verifyDemo : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('otp.verifyBtn'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildPhoneOtpBody() {
    if (_isSending) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text('otp.sending'.tr(), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      );
    }

    if (_verificationId == null) {
      // Failed (or timed out) before a code was ever actually sent — show
      // the error and a retry action, not the code-entry form (there's no
      // verificationId yet for "Verify" to check against, and the resend
      // countdown was never started).
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) Text(_error!, style: const TextStyle(fontSize: 12.5, color: AppColors.red)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _send,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('otp.tryAgain'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _codeField(),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.red)),
        ],
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: (_codeController.text.trim().length == 6 && !_isVerifying) ? _verify : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isVerifying
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('otp.verifyBtn'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 10),
        Center(
          child: _resendSecondsLeft > 0
              ? Text('${'otp.resendIn'.tr()} ${_resendSecondsLeft}s', style: const TextStyle(fontSize: 12, color: AppColors.textFaint))
              : InkWell(
                  onTap: _send,
                  child: Text(
                    'otp.resend'.tr(),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy, decoration: TextDecoration.underline),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _codeField() {
    return TextField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 8),
      decoration: InputDecoration(hintText: 'otp.placeholder'.tr(), counterText: ''),
      onChanged: (_) => setState(() {}),
    );
  }
}
