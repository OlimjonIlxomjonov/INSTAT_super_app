import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_bloc.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_event.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_state.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/requests/requests_card_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VacancyApplicationsWithBlocWg extends StatelessWidget {
  final int? limit;
  final bool isSearching;
  final VoidCallback? onRetry;

  const VacancyApplicationsWithBlocWg({
    super.key,
    this.limit,
    this.isSearching = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<VacancyApplicationsBloc, VacancyApplicationsState>(
      builder: (context, state) {
        if (state is VacancyApplicationsError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SectionErrorWg(
                title: state.message,
                onRetry:
                    onRetry ??
                    () => context.read<VacancyApplicationsBloc>().add(
                      const FetchVacancyApplicationsEvent(),
                    ),
              ),
            ),
          );
        }

        if (state is VacancyApplicationsLoaded) {
          final data = limit == null
              ? state.response.data
              : state.response.data.take(limit!).toList();

          if (data.isEmpty) {
            return SliverToBoxAdapter(
              child: AppEmptyState(
                title: isSearching ? l.nothingFound : l.noApplicationsYet,
                subtitle: '',
              ),
            );
          }

          return SliverOpacity(
            opacity: state.isRefreshing ? 0.4 : 1,
            sliver: SliverList.separated(
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => RequestsCardWg(item: data[index]),
            ),
          );
        }

        //! Skeleton
        return Skeletonizer.sliver(
          child: SliverList.separated(
            itemCount: limit ?? 3,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) =>
                const RequestsCardWg(item: _skeletonApplication),
          ),
        );
      },
    );
  }
}

//! Skeleton uchun
const _skeletonApplication = VacancyApplicationEntity(
  id: 0,
  status: 'saralash',
  vacancy: VacancyEntity(
    id: 0,
    position: VacancyRefEntity(id: 0, name: 'Senior Frontend Developer'),
    specialization: VacancyRefEntity(id: 0, name: 'Operator'),
  ),
);
