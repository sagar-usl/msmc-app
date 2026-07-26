/// A small bilingual string holder for content data (lists of documents,
/// news, scheme categories, etc.) that comes from a future content API
/// rather than from the UI-chrome translation JSON files. Keeping `en`/`mr`
/// side by side here mirrors the prototype's `T = { en: {...}, mr: {...} }`
/// data blocks and gives the future backend content payload an obvious
/// shape to map onto (`title_en`/`title_mr` columns, see the plan doc).
class Bi {
  final String en;
  final String mr;
  const Bi(this.en, this.mr);

  String of(String languageCode) => languageCode == 'mr' ? mr : en;
}
