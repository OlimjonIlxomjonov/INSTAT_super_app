import 'package:flutter/material.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';

class DetailTabItem {
  final String label;
  final IconData icon;

  const DetailTabItem({required this.label, required this.icon});
}

class DetailTabsWg extends StatelessWidget {
  final List<DetailTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DetailTabsWg({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(right: 20, bottom: 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          return EduCategoriesWg(
            categoryIcon: tabs[index].icon,
            categoryName: tabs[index].label,
            isSelected: selectedIndex == index,
            onTap: () => onChanged(index),
          );
        }),
      ),
    );
  }
}
