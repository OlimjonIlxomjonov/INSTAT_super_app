/// Dizaynda sanalar `12.02.2023` ko'rinishida. Loyihadagi `toReadableDate()`
/// esa "12 Fevral 2023, 14:30" beradi va oy nomlari faqat o'zbekcha —
/// shuning uchun bu yerda alohida formatter.
String formatRequestDate(DateTime? date) {
  if (date == null) return '';
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}

/// Fayl 1 GB gacha bo'lishi mumkin, shuning uchun GB ham qo'llab-quvvatlanadi.
String formatRequestFileSize(int? bytes) {
  if (bytes == null || bytes <= 0) return '';
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
  return '${(mb / 1024).toStringAsFixed(2)} GB';
}
