import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_group_entity.dart';

import '../../../../../../../core/utils/app_utils.dart';
import '../../../../../../../core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';

class OfflineCourseWg extends StatelessWidget {
  final OfflineGroupEntity _item;

  const OfflineCourseWg({super.key, required OfflineGroupEntity item})
    : _item = item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .fromLTRB(20, 0, 20, 12),
      padding: .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: .all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(16),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: .start,
        children: [
          Text(_item.name, style: AppTextStyles.source.medium(fontSize: 16)),
          Row(
            crossAxisAlignment: .center,
            spacing: 4,
            children: [
              Icon(IconlyLight.calendar, color: AppColors.greyScale.grey600),
              Text(
                _item.course.category?.createdAt.toReadableDate() ?? '',
                style: _subStyle(),
              ),
            ],
          ),
          Row(
            spacing: 4,
            crossAxisAlignment: .center,
            children: [
              Icon(IconlyLight.profile, color: AppColors.greyScale.grey600),
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(_item.teachers.length, (index) {
                    final teacher = _item.teachers[index];
                    return Text(
                      "${teacher.fullName.capitalize()},",
                      style: _subStyle(),
                    );
                  }),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: CustomLinearIndicatorWg(progressIndicator: 25)),
              SizedBox(width: 10),
              Text('25%', style: _subStyle()),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _subStyle() {
    return AppTextStyles.source.regular(
      fontSize: 13,
      color: AppColors.greyScale.grey600,
    );
  }
}
