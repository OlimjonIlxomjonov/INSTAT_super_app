import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_state.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_card_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Ro'yxat sliveri — bloc holatiga qarab skeleton / bo'sh / xato / kartalar.
class VacanciesWithBlocWg extends StatelessWidget {
  final int? limit;
  final bool isSearching;
  final VoidCallback? onRetry;

  const VacanciesWithBlocWg({
    super.key,
    this.limit,
    this.isSearching = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<VacanciesBloc, VacanciesState>(
      builder: (context, state) {
        if (state is VacanciesError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SectionErrorWg(title: state.message, onRetry: onRetry),
            ),
          );
        }

        if (state is VacanciesLoaded) {
          final data = limit == null
              ? state.response.data
              : state.response.data.take(limit!).toList();

          if (data.isEmpty) {
            return SliverToBoxAdapter(
              child: AppEmptyState(
                title: isSearching ? l.nothingFound : l.noVacanciesYet,
                subtitle: '',
              ),
            );
          }

          return SliverOpacity(
            opacity: state.isRefreshing ? 0.4 : 1,
            sliver: SliverList.separated(
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => VacancyCardWg(item: data[index]),
            ),
          );
        }

        //! Skeleton
        return Skeletonizer.sliver(
          child: SliverList.separated(
            itemCount: limit ?? 3,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => VacancyCardWg(item: _skeletonVacancy),
          ),
        );
      },
    );
  }
}

//! Skeleton uchun
const _skeletonVacancy = VacancyEntity(
  id: 0,
  position: VacancyRefEntity(id: 0, name: 'Senior Frontend Developer'),
  specialization: VacancyRefEntity(id: 0, name: 'Operator'),
  department: VacancyDepartmentEntity(id: 0, name: 'Toshkent shahri'),
  employmentType: 'full_time',
  experience: '3-4',
  salaryFrom: 1000000,
  salaryTo: 2000000,
  quantity: 1,
);
