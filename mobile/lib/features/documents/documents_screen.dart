import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/open_url.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/async_screen.dart';
import '../../core/widgets/screen_header.dart';
import 'data/documents_repository.dart';
import 'providers/documents_provider.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  ApiDocCategory? _active; // null = All
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final docsAsync = ref.watch(documentsProvider);

    return Column(
      children: [
        ScreenHeader(
          title: 'documents.title'.tr(),
          trailing: InkWell(
            customBorder: const CircleBorder(),
            onTap: _toggleSearch,
            child: SizedBox(
              width: 34,
              height: 34,
              child: Icon(_isSearching ? Icons.close : Icons.search, size: 19, color: AppColors.navy),
            ),
          ),
        ),
        if (_isSearching)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: lang == 'mr' ? 'शीर्षकाने शोधा...' : 'Search by title...',
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(documentsProvider.notifier).refresh(),
            child: AsyncScreen(
              value: docsAsync,
              onRetry: () => ref.read(documentsProvider.notifier).refresh(),
              builder: (items) {
                final filtered = items
                    .where((d) => _active == null || d.category == _active)
                    .where((d) => _query.isEmpty || d.title(lang).toLowerCase().contains(_query))
                    .toList();
                return Column(
                  children: [
                    // Category filter chips
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                      child: SizedBox(
                        height: 34,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _chip(lang == 'mr' ? 'सर्व' : 'All', null),
                            const SizedBox(width: 8),
                            _chip(lang == 'mr' ? 'अहवाल' : 'Reports', ApiDocCategory.REPORTS),
                            const SizedBox(width: 8),
                            _chip(lang == 'mr' ? 'कायदे' : 'Acts & Rules', ApiDocCategory.ACTS),
                            const SizedBox(width: 8),
                            _chip(lang == 'mr' ? 'धोरणे' : 'Policies', ApiDocCategory.POLICIES),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                _query.isNotEmpty
                                    ? (lang == 'mr' ? 'कोणतेही दस्तऐवज जुळत नाहीत.' : 'No documents match your search.')
                                    : 'No documents.',
                                style: const TextStyle(color: AppColors.textMuted),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, i) {
                                final doc = filtered[i];
                                final tint = _tintFor(doc.category);
                                final fileUrl = doc.absoluteFileUrl();
                                return AppCard(
                                  padding: const EdgeInsets.all(14),
                                  radius: 14,
                                  shadowOpacity: 0.06,
                                  shadowBlur: 8,
                                  onTap: fileUrl != null ? () => openExternalUrl(context, fileUrl) : null,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42, height: 42,
                                        decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(10)),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.description_outlined, size: 19, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(doc.title(lang), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryAlt)),
                                            const SizedBox(height: 2),
                                            Text(doc.meta(lang) ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textFaint)),
                                          ],
                                        ),
                                      ),
                                      if (fileUrl != null)
                                        const Icon(Icons.file_download_outlined, size: 18, color: AppColors.navy),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, ApiDocCategory? cat) {
    final active = cat == _active;
    return GestureDetector(
      onTap: () => setState(() => _active = cat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : AppColors.background,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textMuted)),
      ),
    );
  }

  Color _tintFor(ApiDocCategory cat) => switch (cat) {
    ApiDocCategory.REPORTS  => AppColors.navy,
    ApiDocCategory.ACTS     => AppColors.saffron,
    ApiDocCategory.POLICIES => AppColors.green,
  };
}
