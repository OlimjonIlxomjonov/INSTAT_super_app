import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';

//! Backend `reviews/?status=` qabul qiladigan qiymatlar
const List<String> articleStatus = [
  'all',
  'published',
  'waiting_for_payment',
  'in_review',
  'rejected',
  'draft',
];

List<String> articleCategories(AppLocalizations l) => [
  l.categoryAll,
  l.published,
  l.statusWaitingForPayment,
  l.statusUnderReview,
  l.statusRejected,
  l.statusDraft,
];

const List<IconData> categoriesIcon = [
  IconlyLight.discovery,
  IconlyLight.tickSquare,
  IconlyLight.wallet,
  IconlyLight.dangerTriangle,
  IconlyLight.dangerCircle,
  IconlyLight.paper,
];
