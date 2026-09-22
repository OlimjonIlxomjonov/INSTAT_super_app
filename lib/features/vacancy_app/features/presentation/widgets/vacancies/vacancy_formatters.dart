import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';

const List<String> kEmploymentTypes = ['full_time', 'part_time', 'remote'];
const List<String> kApplicationStatuses = [
  'saralash',
  'reserved',
  'test',
  'failed_test',
  'interview',
  'qoshimcha_suhbat',
  'failed',
];

//! Sana
String formatVacancyDate(DateTime? date) {
  if (date == null) return '';
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$d.$m.${date.year}';
}

String formatVacancyDateTime(DateTime? date) {
  if (date == null) return '';
  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$h:$min ${formatVacancyDate(date)}';
}

String formatVacancyPeriod(VacancyEntity item) {
  final from = formatVacancyDate(item.publishedAt ?? item.createdAt);
  final to = formatVacancyDate(item.expireAt);
  if (from.isNotEmpty && to.isNotEmpty) return '$from - $to';
  return from.isNotEmpty ? from : to;
}

//! Maosh
String formatVacancySalary(AppLocalizations l, VacancyEntity item) {
  final from = item.salaryFrom;
  final to = item.salaryTo;
  if (from == null && to == null) return '—';
  if (from != null && to != null && from != to) {
    return l.salaryRange(formatPrice(from), formatPrice(to));
  }
  return '${formatPrice(from ?? to!)} UZS';
}

//! Ish turi
String employmentTypeLabel(AppLocalizations l, String? type) {
  switch (type) {
    case 'full_time':
      return l.employmentFullTime;
    case 'part_time':
      return l.employmentPartTime;
    case 'remote':
      return l.employmentRemote;
    case 'contract':
      return l.employmentContract;
    case 'internship':
      return l.employmentInternship;
    default:
      return type ?? '—';
  }
}

//! Ariza holati
String applicationStatusLabel(AppLocalizations l, String? status) {
  switch (status) {
    case 'saralash':
      return l.applicationStatusSaralash;
    case 'reserved':
      return l.applicationStatusReserved;
    case 'test':
      return l.applicationStatusTest;
    case 'failed_test':
      return l.applicationStatusFailedTest;
    case 'interview':
      return l.applicationStatusInterview;
    case 'qoshimcha_suhbat':
      return l.applicationStatusExtraInterview;
    case 'failed':
      return l.applicationStatusFailed;
    default:
      return status ?? '—';
  }
}

class ApplicationStatusStyle {
  final IconData icon;
  final Color color;
  final Color background;

  const ApplicationStatusStyle({
    required this.icon,
    required this.color,
    required this.background,
  });
}

ApplicationStatusStyle applicationStatusStyle(String? status) {
  switch (status) {
    case 'saralash':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.loader_2_line,
        color: AppColors.orange500,
        background: AppColors.orange50,
      );
    case 'reserved':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.bookmark_line,
        color: AppColors.indigo,
        background: Color(0xffECF0FA),
      );
    case 'test':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.file_list_3_line,
        color: AppColors.primaryColor,
        background: AppColors.iconBlueBackground,
      );
    case 'failed_test':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.close_circle_line,
        color: AppColors.iconRed,
        background: AppColors.iconRedBackground,
      );
    case 'failed':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.forbid_2_line,
        color: AppColors.iconRed,
        background: AppColors.iconRedBackground,
      );
    case 'interview':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.chat_3_line,
        color: AppColors.purple,
        background: Color(0xffF3EFFF),
      );
    case 'qoshimcha_suhbat':
      return const ApplicationStatusStyle(
        icon: FlutterRemix.chat_check_line,
        color: AppColors.teal,
        background: Color(0xffE6F4F3),
      );
    default:
      return ApplicationStatusStyle(
        icon: FlutterRemix.information_line,
        color: AppColors.greyScale.grey600,
        background: AppColors.greyScale.grey100,
      );
  }
}
