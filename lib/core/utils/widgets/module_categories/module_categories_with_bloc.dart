import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/module_category/module_category_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/module_category/module_category_state.dart';

import '../../../../features/main_app/home/presentation/bloc/home_event.dart';

class ModuleCategoriesWithBlocWg extends StatefulWidget {
  final String categoryType;
  final ValueChanged<int>? onCategoryTap;

  const ModuleCategoriesWithBlocWg({
    super.key,
    required this.categoryType,
    this.onCategoryTap,
  });

  @override
  State<ModuleCategoriesWithBlocWg> createState() =>
      _ModuleCategoriesWithBlocWgState();
}

class _ModuleCategoriesWithBlocWgState
    extends State<ModuleCategoriesWithBlocWg> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ModuleCategoryBloc>().add(
      ModuleCategoryEvent(
        params: ModuleCategoryParams(type: widget.categoryType, page: '1'),
      ),
    );
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    widget.onCategoryTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModuleCategoryBloc, ModuleCategoryState>(
      builder: (context, state) {
        if (state is ModuleCategoryLoaded) {
          final categories = state.response.data;

          final itemCount = categories.length + 1;

          if (categories.isEmpty) {
            return SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(right: 20),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(itemCount, (index) {
                if (index == 0) {
                  return EduCategoriesWg(
                    categoryIcon: IconlyLight.discovery,
                    isSelected: _selectedIndex == 0,
                    categoryName: 'Barchasi',
                    onTap: () => _onTap(0),
                  );
                }

                final category = categories[index - 1];
                return EduCategoriesWg(
                  categoryIcon: IconlyLight.category,
                  isSelected: _selectedIndex == index,
                  categoryName: category.nameUz,
                  onTap: () => _onTap(index),
                );
              }),
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
