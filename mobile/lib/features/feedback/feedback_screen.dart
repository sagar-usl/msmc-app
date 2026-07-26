import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  int _rating = 0;
  bool _ratingError = false;
  bool _messageError = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    final message = _messageController.text.trim();
    setState(() {
      _ratingError = _rating == 0;
      _messageError = message.length < 5;
    });
    if (_ratingError || _messageError) return;
    setState(() => _submitted = true);
  }

  void _reset() {
    setState(() {
      _nameController.clear();
      _messageController.clear();
      _rating = 0;
      _ratingError = false;
      _messageError = false;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(title: 'feedback.headerTitle'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: _submitted ? _buildThankYou() : _buildForm(),
        ),
      ],
    );
  }

  Widget _buildThankYou() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.greenTint(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 30, color: AppColors.green),
            ),
            const SizedBox(height: 14),
            Text('feedback.thankYou'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('feedback.thankYouSub'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.6)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _reset,
              child: Text(
                'feedback.submitAnother'.tr(),
                style: const TextStyle(color: AppColors.navy, fontSize: 13, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      children: [
        Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.saffronTint(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.forum_outlined, size: 24, color: AppColors.saffron),
            ),
            const SizedBox(height: 8),
            Text('feedback.heading'.tr(), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('feedback.subheading'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final n = i + 1;
                  return IconButton(
                    onPressed: () => setState(() {
                      _rating = n;
                      _ratingError = false;
                    }),
                    icon: Icon(n <= _rating ? Icons.star : Icons.star_border, size: 30, color: AppColors.saffron),
                  );
                }),
              ),
              if (_ratingError)
                Text('feedback.ratingError'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.red)),
              const SizedBox(height: 6),
              Text('feedback.nameLabel'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              TextField(controller: _nameController, decoration: InputDecoration(hintText: 'feedback.namePlaceholder'.tr())),
              const SizedBox(height: 12),
              Text('feedback.feedbackLabel'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              TextField(
                controller: _messageController,
                maxLines: 4,
                onChanged: (_) => setState(() => _messageError = false),
                decoration: InputDecoration(
                  hintText: 'feedback.feedbackPlaceholder'.tr(),
                  errorText: _messageError ? 'feedback.messageError'.tr() : null,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('feedback.submitBtn'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
