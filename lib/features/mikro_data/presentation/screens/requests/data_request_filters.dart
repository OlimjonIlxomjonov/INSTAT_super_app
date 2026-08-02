import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';

/// Requests sahifasidagi status filtrlari.
///
/// [apiValue] to'g'ridan-to'g'ri `?status=` ga ketadi — "barchasi" uchun
/// backend bo'sh qiymat kutadi.
class DataRequestFilter {
  final String apiValue;
  final String label;
  final IconData icon;

  const DataRequestFilter({
    required this.apiValue,
    required this.label,
    required this.icon,
  });
}

List<DataRequestFilter> dataRequestFilters(AppLocalizations localization) {
  return [
    DataRequestFilter(
      apiValue: '',
      label: localization.requestFilterAll,
      icon: IconlyLight.discovery,
    ),
    DataRequestFilter(
      apiValue: 'accepted',
      label: localization.statusConfirmed,
      icon: IconlyLight.tick_square,
    ),
    DataRequestFilter(
      apiValue: 'in_review',
      label: localization.statusUnderReview,
      icon: IconlyLight.danger,
    ),
    DataRequestFilter(
      apiValue: 'pending_payment',
      label: localization.statusPendingPayment,
      icon: IconlyLight.wallet,
    ),
    DataRequestFilter(
      apiValue: 'rejected',
      label: localization.statusRejected,
      icon: IconlyLight.info_circle,
    ),
    DataRequestFilter(
      apiValue: 'draft',
      label: localization.statusDraft,
      icon: IconlyLight.paper,
    ),
  ];
}
