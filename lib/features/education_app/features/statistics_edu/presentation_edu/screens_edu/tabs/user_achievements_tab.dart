import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/body_container.dart';

import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class UserAchievementsTab extends StatelessWidget {
  const UserAchievementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final medals = List.generate(12, (i) => ('🎖️', 'Knowledge\nBuilder'));

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: appH(16)),
      child: BodyContainer(
        title: 'Medallar',
        body: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: medals.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.80,
          ),
          itemBuilder: (context, index) {
            final (icon, title) = medals[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.greyScale.grey200),
                color: AppColors.greyScale.grey50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 26)),
                  SizedBox(height: appH(10)),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.source.medium(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
