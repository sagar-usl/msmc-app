import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shared external-link opener (PDFs, external URLs) — used by Documents,
/// Education, PM Scheme, and Complaint attachments/verdicts. Requires the
/// android.intent.action.VIEW `<queries>` declarations in AndroidManifest.xml
/// for canLaunchUrl to work correctly on Android 11+ — without them this
/// silently reports "can't open" even when a capable app is installed.
Future<void> openExternalUrl(
  BuildContext context,
  String url, {
  String errorMessage = 'Could not open this document.',
}) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
  }
}
