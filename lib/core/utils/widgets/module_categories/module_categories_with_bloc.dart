import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/module_category/module_category_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/module_category/module_category_state.dart';

import '../../../../features/main_app/home/presentation/bloc/home_event.dart';

class ModuleCategoriesWithBlocWg extends StatefulWidget {
  final String categoryType;

  /// Tanlangan kategoriya id'si. "Barchasi" uchun `null` keladi.
  final ValueChanged<int?>? onCategorySelected;

  /// Bloc global bo'lgani uchun modul yopilib qayta ochilganda ro'yxat eski
  /// filtrda qoladi — chip ham o'sha filtrni ko'rsatsin.
  final int? initialSelectedId;

  const ModuleCategoriesWithBlocWg({
    super.key,
    required this.categoryType,
    this.onCategorySelected,
    this.initialSelectedId,
  });

  @override
  State<ModuleCategoriesWithBlocWg> createState() =>
      _ModuleCategoriesWithBlocWgState();
}

class _ModuleCategoriesWithBlocWgState
    extends State<ModuleCategoriesWithBlocWg> {
  late int? _selectedId = widget.initialSelectedId;

  @override
  void initState() {
    super.initState();
    context.read<ModuleCategoryBloc>().add(
      ModuleCategoryEvent(
        params: ModuleCategoryParams(type: widget.categoryType, page: '1'),
      ),
    );
  }

  void _onTap(int? categoryId) {
    if (_selectedId == categoryId) return;
    setState(() => _selectedId = categoryId);
    widget.onCategorySelected?.call(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return BlocBuilder<ModuleCategoryBloc, ModuleCategoryState>(
      builder: (context, state) {
        if (state is ModuleCategoryLoaded) {
          final categories = state.response.data;

          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(right: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                EduCategoriesWg(
                  categoryIcon: IconlyLight.discovery,
                  isSelected: _selectedId == null,
                  categoryName: localization.categoryAll,
                  onTap: () => _onTap(null),
                ),
                ...categories.map(
                  (category) => EduCategoriesWg(
                    categoryIcon: IconlyLight.category,
                    isSelected: _selectedId == category.id,
                    categoryName: category.displayName(localeCode),
                    onTap: () => _onTap(category.id),
                  ),
                ),
              ],
            ),
          );
        }

        return Skeletonizer(
          enabled: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(right: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (_) => const EduCategoriesWg()),
            ),
          ),
        );
      },
    );
  }
}
