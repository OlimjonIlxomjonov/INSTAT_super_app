import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/detail_tabs/detail_tabs_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/processes/vacancy_processes_cubit.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_application_status_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_processes_with_bloc_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_body_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_field_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

class VacancyApplicationDetailWg extends StatelessWidget {
  final VacancyApplicationEntity item;

  const VacancyApplicationDetailWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VacancyProcessesCubit>()..load(item.id),
      child: _VacancyApplicationDetailView(item: item),
    );
  }
}

class _VacancyApplicationDetailView extends StatefulWidget {
  final VacancyApplicationEntity item;

  const _VacancyApplicationDetailView({required this.item});

  @override
  State<_VacancyApplicationDetailView> createState() =>
      _VacancyApplicationDetailViewState();
}

class _VacancyApplicationDetailViewState
    extends State<_VacancyApplicationDetailView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverToBoxAdapter(
            child: SheetDragAreaWg(
              child: CustomAppBarWg(
                myTitle: localization.applicationDetailsTitle,
                isFamily: true,
              ),
            ),
          ),

          //! Tabs
          SliverToBoxAdapter(
            child: DetailTabsWg(
              tabs: [
                DetailTabItem(
                  label: localization.applicationInfoTab,
                  icon: FlutterRemix.file_list_2_line,
                ),
                DetailTabItem(
                  label: localization.requestTabProcesses,
                  icon: FlutterRemix.list_check_2,
                ),
              ],
              selectedIndex: _selectedTab,
              onChanged: (index) => setState(() => _selectedTab = index),
            ),
          ),

          //! Body
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            sliver: SliverToBoxAdapter(
              child: _selectedTab == 0
                  ? _buildInfoTab()
                  : VacancyProcessesWithBlocWg(
                      onRetry: () => context.read<VacancyProcessesCubit>().load(
                        widget.item.id,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    final localization = AppLocalizations.of(context)!;
    final item = widget.item;
    final candidate = item.candidate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Sana va status
        Row(
          children: [
            Icon(
              FlutterRemix.calendar_line,
              size: 18,
              color: AppColors.greyScale.grey600,
            ),
            const SizedBox(width: 6),
            Text(
              formatVacancyDate(item.createdAt),
              style: AppTextStyles.source.medium(
                fontSize: 14,
                color: AppColors.greyScale.grey700,
              ),
            ),
            const Spacer(),
            VacancyApplicationStatusWg(status: item.status),
          ],
        ),
        const SizedBox(height: 16),

        if (item.vacancy != null) ...[
          VacancyInfoBodyWg(item: item.vacancy!),
          const SizedBox(height: 16),
        ],

        //! Shaxsiy ma’lumotlar
        if (candidate != null)
          VacancySectionCardWg(
            title: localization.myPersonalInfo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VacancyInfoFieldWg(
                  label: localization.fullNameLabel,
                  value: candidate.fullName,
                ),
                const SizedBox(height: 16),
                VacancyInfoFieldWg(
                  label: localization.birthDateLabel,
                  value: formatVacancyDate(candidate.birthDate),
                ),
                const SizedBox(height: 16),
                VacancyInfoFieldWg(
                  label: localization.emailAddressLabel,
                  value: candidate.email,
                ),
                const SizedBox(height: 16),
                VacancyInfoFieldWg(
                  label: localization.phoneNumberLabel,
                  value: candidate.phoneNumber,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
