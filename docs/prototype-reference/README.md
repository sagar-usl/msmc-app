# Prototype → app content mapping

The bilingual (EN/मराठी) copy and seed data used by the Flutter app and backend content tables were transcribed directly from the root-level prototype's `.dc.html` files — specifically each screen's inline `T = { en: {...}, mr: {...} }` script block.

Current locations of that transcription:

- UI-chrome strings (labels, headers, buttons, form placeholders/errors): `mobile/assets/translations/en.json` and `mr.json`.
- List-shaped content data (documents, initiatives, scheme categories, news, education items, PM scheme's 15 points, commission members, home carousel slides, complaint seed data): `mobile/lib/features/*/data/*_content.dart` and `*_seed.dart`, using the small `Bi(en, mr)` bilingual-string helper (`mobile/lib/core/localization/bi.dart`).

When the backend content endpoints are wired up (Phase 1 of the build plan), `backend/seeds/seed-content.js` should source from these same Dart data files (or a shared JSON export of them) so there is exactly one place the prototype's original copy lives, not three.
