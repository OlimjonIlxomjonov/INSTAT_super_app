import 'package:my_template/core/l10n/app_localizations.dart';

/// 05:00–11:59 tong · 12:00–17:59 kun · 18:00–21:59 kech · qolgani tun
String timeGreeting(AppLocalizations l, [DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;

  if (hour >= 5 && hour < 12) return l.goodMorning;
  if (hour >= 12 && hour < 18) return l.goodAfternoon;
  if (hour >= 18 && hour < 22) return l.goodEvening;
  return l.goodNight;
}
