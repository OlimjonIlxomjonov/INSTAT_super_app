import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applied_check/vacancy_applied_cubit.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_applied_bar_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_apply_form_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_body_wg.dart';

class VacancyDetailedWg extends StatelessWidget {
  final VacancyEntity item;

  const VacancyDetailedWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VacancyAppliedCubit>()..check(item.id),
      child: _VacancyDetailedView(item: item),
    );
  }
}

class _VacancyDetailedView extends StatelessWidget {
  final VacancyEntity item;

  const _VacancyDetailedView({required this.item});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: localization.vacancyDetailsTitle),
            ),
          ),

          //! Body
          SliverPadding(
            padding: const .symmetric(horizontal: 20, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  //! E’lon sanasi
                  Row(
                    children: [
                      Text(
                        localization.publishedDateLabel,
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          formatVacancyPeriod(item),
                          style: AppTextStyles.source.medium(
                            fontSize: 14,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  VacancyInfoBodyWg(item: item),
                ],
              ),
            ),
          ),
        ],
      ),
      //! Ariza holati
      bottomNavigationBar:
          BlocBuilder<VacancyAppliedCubit, VacancyAppliedState>(
            builder: (context, state) {
              if (state.status == VacancyAppliedStatus.applied) {
                return VacancyAppliedBarWg(application: state.application!);
              }
              return CustomBottomNavContainerWg(
                buttonText: localization.submitApplication,
                isLoading: state.status == VacancyAppliedStatus.loading,
                onTap: () => openMiniAppSheetFamily(
                  context,
                  child: VacancyApplyFormWg(
                    vacancyId: item.id,
                    onSubmitted: () =>
                        context.read<VacancyAppliedCubit>().check(item.id),
                  ),
                  showHandler: false,
                ),
              );
            },
          ),
    );
  }
}
