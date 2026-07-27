import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_exception.dart';
import '../theme/app_colors.dart';

/// Renders [AsyncValue] states in a consistent way across all content screens.
///
/// Usage:
/// ```dart
/// AsyncScreen(
///   value: ref.watch(newsProvider),
///   builder: (items) => MyList(items),
/// )
/// ```
class AsyncScreen<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  const AsyncScreen({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: AppColors.navy, strokeWidth: 2.5),
        ),
      ),
      error: (err, _) {
        final msg = err is ApiException ? err.userMessage : 'Something went wrong.';
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_outlined, size: 40, color: AppColors.textFaint),
                const SizedBox(height: 12),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.6),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('Try Again', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      data: builder,
    );
  }
}
