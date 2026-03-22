import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class CoursePlanTab extends StatelessWidget {
  const CoursePlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            left: appW(20),
            right: appW(20),
            bottom: appH(20),
          ),
          sliver: SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyScale.grey200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(4, (index) {
                    return _SectionTile(index: index, isLast: index == 3);
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  final int index;
  final bool isLast;

  const _SectionTile({required this.index, required this.isLast});

  static const List<Widget> _lessons = [
    _LessonItem(),
    _LessonItem(),
    _LessonItem(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            "Tarmoqlar bo'yicha statistika asoslari",
            style: AppTextStyles.source.regular(fontSize: 14),
          ),
          initiallyExpanded: index == 0,
          tilePadding: EdgeInsets.only(
            top: appH(5),
            bottom: appH(5),
            left: appW(10),
          ),
          children: [
            Divider(color: AppColors.greyScale.grey200, height: 1),
            ..._lessons,
          ],
        ),
        if (!isLast) Divider(color: AppColors.greyScale.grey200, height: 1),
      ],
    );
  }
}

class _LessonItem extends StatelessWidget {
  const _LessonItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.video_collection),
      title: Text(
        "Statistik ko'rsatkichlar va ularning turlari",
        style: AppTextStyles.source.regular(fontSize: 13),
      ),
      tileColor: AppColors.greyScale.grey100,
    );
  }
}
