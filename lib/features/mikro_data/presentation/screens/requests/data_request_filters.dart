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
      apiValue: 'draft',
      label: localization.statusDraft,
      icon: IconlyLight.paper,
    ),
    DataRequestFilter(
      apiValue: 'in_review',
      label: localization.statusUnderReview,
      icon: IconlyLight.danger,
    ),
    DataRequestFilter(
      apiValue: 'in_process',
      label: localization.statusInProcess,
      icon: IconlyLight.time_circle,
    ),
    DataRequestFilter(
      apiValue: 'agreement_accepted',
      label: localization.statusAgreementAccepted,
      icon: IconlyLight.tick_square,
    ),
    DataRequestFilter(
      apiValue: 'head_agreement_accepted',
      label: localization.statusHeadAgreementAccepted,
      icon: IconlyLight.shield_done,
    ),
    DataRequestFilter(
      apiValue: 'waiting_for_payment',
      label: localization.statusWaitingForPayment,
      icon: IconlyLight.wallet,
    ),
    DataRequestFilter(
      apiValue: 'paid',
      label: localization.statusPaid,
      icon: IconlyLight.wallet,
    ),
    DataRequestFilter(
      apiValue: 'finished',
      label: localization.statusFinished,
      icon: IconlyLight.tick_square,
    ),
    DataRequestFilter(
      apiValue: 'rejected',
      label: localization.statusRejected,
      icon: IconlyLight.info_circle,
    ),
  ];
}
