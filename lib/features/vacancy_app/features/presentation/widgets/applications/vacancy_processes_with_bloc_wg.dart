import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_process_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/processes/vacancy_processes_cubit.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_process_item.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_processes_tab_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VacancyProcessesWithBlocWg extends StatelessWidget {
  final VoidCallback? onRetry;

  const VacancyProcessesWithBlocWg({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<VacancyProcessesCubit, VacancyProcessesState>(
      builder: (context, state) {
        if (state is VacancyProcessesError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SectionErrorWg(title: state.message, onRetry: onRetry),
          );
        }

        final items = state is VacancyProcessesLoaded
            ? state.items
            : _skeletonProcesses;

        return Skeletonizer(
          enabled: state is! VacancyProcessesLoaded,
          child: VacancyProcessesTabWg(
            items: [for (final item in items) _toProcessItem(l, item)],
            emptyTitle: l.noProcessesYet,
            cycleLabel: (cycle) => l.cycleLabel(cycle),
          ),
        );
      },
    );
  }

  VacancyProcessItem _toProcessItem(
    AppLocalizations l,
    VacancyProcessEntity process,
  ) {
    final title = applicationStatusLabel(l, process.status);
    final style = applicationStatusStyle(process.status);
    final comment = process.comment ?? '';
    final user = process.user;
    return VacancyProcessItem(
      cycle: 1,
      title: title,
      description: comment,
      date: formatVacancyDateTime(process.createdAt),
      icon: style.icon,
      color: style.color,
      detailTitle: title,
      detailDescription: comment.isEmpty ? null : comment,
      fields: [
        if (process.address != null && process.address!.isNotEmpty)
          VacancyProcessField(label: l.addressLabel, value: process.address!),
        if (process.contact != null && process.contact!.isNotEmpty)
          VacancyProcessField(label: l.contactLabel, value: process.contact!),
        if (process.assignedAt != null)
          VacancyProcessField(
            label: l.assignedAtLabel,
            value: formatVacancyDateTime(process.assignedAt),
          ),
      ],
      commission: [
        if (user != null && user.fullName.isNotEmpty)
          VacancyCommissionMember(
            name: user.fullName,
            phone: user.email,
            avatarUrl: user.avatar,
          ),
      ],
    );
  }
}

//! Skeleton uchun
final _skeletonProcesses = [
  VacancyProcessEntity(id: 0, status: 'saralash', createdAt: DateTime(2026)),
  VacancyProcessEntity(id: 1, status: 'test', createdAt: DateTime(2026)),
  VacancyProcessEntity(id: 2, status: 'interview', createdAt: DateTime(2026)),
];
