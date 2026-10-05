import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

//! Narx 0 bo'lsa kursdagidek "Bepul"
String priceLabel(AppLocalizations l, Object price) {
  final value = price is num ? price : (num.tryParse(price.toString()) ?? 0);
  return value == 0 ? l.freePrice : '${formatPrice(value)} UZS';
}
