import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

class VacancyApplicationStatusWg extends StatelessWidget {
  final String status;

  const VacancyApplicationStatusWg({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final style = applicationStatusStyle(status);
    return StatusContainerWg(
      icon: style.icon,
      statusTitle: ' ${applicationStatusLabel(l, status)}',
      iconColor: style.color,
      backgroundColor: style.background,
    );
  }
}
