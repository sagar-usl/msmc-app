import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/screen_header.dart';
import 'data/initiatives_repository.dart';

class InitiativeDetailScreen extends StatelessWidget {
  final InitiativeApiItem item;
  const InitiativeDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final imageUrls = item.imageUrls();

    return Column(
      children: [
        ScreenHeader(title: item.title(lang), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              if (imageUrls.isNotEmpty)
                _FullImageGallery(imageUrls: imageUrls)
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const AspectRatio(aspectRatio: 4 / 3, child: _ImagePlaceholder()),
                ),
              const SizedBox(height: 16),
              Text(item.title(lang), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.navy),
                  const SizedBox(width: 5),
                  Text(item.district(lang), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                ],
              ),
              if (item.description(lang).isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(item.description(lang), style: const TextStyle(fontSize: 13, color: AppColors.textBody, height: 1.7)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FullImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  const _FullImageGallery({required this.imageUrls});

  @override
  State<_FullImageGallery> createState() => _FullImageGalleryState();
}

class _FullImageGalleryState extends State<_FullImageGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_page + delta).clamp(0, widget.imageUrls.length - 1);
    _controller.animateToPage(next, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
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
            if (widget.imageUrls.length > 1) ...[
              if (_page > 0)
                Positioned(
                  left: 6,
                  top: 0,
                  bottom: 0,
                  child: Center(child: _NavArrow(icon: Icons.chevron_left, onTap: () => _go(-1))),
                ),
              if (_page < widget.imageUrls.length - 1)
                Positioned(
                  right: 6,
                  top: 0,
                  bottom: 0,
                  child: Center(child: _NavArrow(icon: Icons.chevron_right, onTap: () => _go(1))),
                ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      '${_page + 1} / ${widget.imageUrls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.black.withValues(alpha: 0.35),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(6), child: Icon(icon, color: Colors.white, size: 22)),
    ),
  );
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
    child: const Center(child: Icon(Icons.image_outlined, color: Colors.white38, size: 40)),
  );
}
