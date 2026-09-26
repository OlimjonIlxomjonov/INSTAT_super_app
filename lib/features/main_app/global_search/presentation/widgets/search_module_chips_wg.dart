import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_cubit.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_state.dart';

String searchModuleLabel(AppLocalizations l, SearchModule module) =>
    switch (module) {
      SearchModule.courses => l.searchGroupCourses,
      SearchModule.books => l.searchGroupBooks,
      SearchModule.magazines => l.searchGroupMagazines,
      SearchModule.reports => l.searchGroupReports,
      SearchModule.vacancies => l.searchGroupVacancies,
    };

class SearchModuleChipsWg extends StatelessWidget {
  final GlobalSearchState state;

  const SearchModuleChipsWg({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cubit = context.read<GlobalSearchCubit>();
    final modules = state.filledModules;

    //! Bitta modul qolsa filtr keraksiz
    if (modules.length < 2) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _Chip(
            label: l.categoryAll,
            isSelected: state.selectedModule == null,
            onTap: () => cubit.selectModule(null),
          ),
          for (final module in modules)
            _Chip(
              label:
                  '${searchModuleLabel(l, module)} ${state.totalFor(module)}',
              isSelected: state.selectedModule == module,
              onTap: () => cubit.selectModule(module),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyScale.grey100,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.greyScale.grey200,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.source.medium(
              fontSize: 13,
              color: isSelected ? AppColors.white : AppColors.greyScale.grey700,
            ),
          ),
        ),
      ),
    );
  }
}
