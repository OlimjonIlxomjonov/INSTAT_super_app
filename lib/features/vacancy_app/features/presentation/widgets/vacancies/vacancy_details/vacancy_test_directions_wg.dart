import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_test_direction_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/test_directions/vacancy_test_directions_cubit.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_score_row_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VacancyTestDirectionsWg extends StatelessWidget {
  final int vacancyId;

  const VacancyTestDirectionsWg({super.key, required this.vacancyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VacancyTestDirectionsCubit>()..load(vacancyId),
      child: _VacancyTestDirectionsView(vacancyId: vacancyId),
    );
  }
}

class _VacancyTestDirectionsView extends StatelessWidget {
  final int vacancyId;

  const _VacancyTestDirectionsView({required this.vacancyId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<VacancyTestDirectionsCubit, VacancyTestDirectionsState>(
      builder: (context, state) {
        if (state is VacancyTestDirectionsError) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SectionErrorWg(
              title: state.message,
              onRetry: () =>
                  context.read<VacancyTestDirectionsCubit>().load(vacancyId),
            ),
          );
        }

        //! Yo'nalish yo'q bo'lsa ko'rinmasin
        if (state is VacancyTestDirectionsLoaded && state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        final items = state is VacancyTestDirectionsLoaded
            ? state.items
            : _skeletonItems;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Skeletonizer(
            enabled: state is! VacancyTestDirectionsLoaded,
            child: VacancySectionCardWg(
              title: l.testDirectionsTitle,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        l.directionNameLabel,
                        style: AppTextStyles.source.regular(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l.passingScoreLabel,
                        style: AppTextStyles.source.regular(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (final (index, item) in items.indexed) ...[
                    if (index > 0) const SizedBox(height: 8),
                    VacancyScoreRowWg(
                      name: item.title,
                      minLabel: l.minScoreValue(item.minScore),
                      maxLabel: l.maxScoreValue(item.maxScore),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//! Skeleton uchun
const _skeletonItems = [
  VacancyTestDirectionEntity(
    id: 0,
    title: 'Matematika',
    minScore: 30,
    maxScore: 100,
  ),
  VacancyTestDirectionEntity(
    id: 1,
    title: 'Ona tili',
    minScore: 30,
    maxScore: 100,
  ),
];
