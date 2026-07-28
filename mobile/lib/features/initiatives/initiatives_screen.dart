import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/async_screen.dart';
import '../../core/widgets/screen_header.dart';
import 'data/initiatives_repository.dart';
import 'providers/initiatives_provider.dart';

class InitiativesScreen extends ConsumerWidget {
  const InitiativesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.locale.languageCode;
    final initAsync = ref.watch(initiativesProvider);

    return Column(
      children: [
        ScreenHeader(title: 'initiatives.title'.tr()),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(initiativesProvider.notifier).refresh(),
            child: AsyncScreen(
              value: initAsync,
              onRetry: () => ref.read(initiativesProvider.notifier).refresh(),
              builder: (items) => items.isEmpty
                  ? const Center(child: Text('No initiatives.', style: TextStyle(color: AppColors.textMuted)))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _InitiativeCard(item: items[i], lang: lang),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InitiativeCard extends StatelessWidget {
  final InitiativeApiItem item;
  final String lang;

  const _InitiativeCard({required this.item, required this.lang});

  @override
  Widget build(BuildContext context) {
    final imageUrls = item.imageUrls();
    return AppCard(
      padding: EdgeInsets.zero,
      radius: 16,
      shadowOpacity: 0.14,
      shadowBlur: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: imageUrls.isEmpty
                  ? const _ImagePlaceholder()
                  : _ImageCarousel(imageUrls: imageUrls),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title(lang), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.navy),
                    const SizedBox(width: 4),
                    Text(item.district(lang), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                  ],
                ),
                if (item.description(lang).isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(item.description(lang), style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  const _ImageCarousel({required this.imageUrls});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.imageUrls.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, i) => Image.network(
            widget.imageUrls[i],
            fit: BoxFit.cover,
            loadingBuilder: (_, child, prog) => prog == null ? child : const _ImagePlaceholder(),
            errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
          ),
        ),
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (i) {
                final active = i == _page;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: active ? 14 : 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: active ? 0.95 : 0.55),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.navy, AppColors.navyLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Center(child: Icon(Icons.image_outlined, color: Colors.white38, size: 30)),
  );
}
