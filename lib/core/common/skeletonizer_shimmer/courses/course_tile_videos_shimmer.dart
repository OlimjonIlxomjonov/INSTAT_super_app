import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CourseTileVideosShimmer extends StatelessWidget {
  const CourseTileVideosShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '01. Loading Topic Title...',
                style: AppTextStyles.source.semiBold(fontSize: 17),
              ),
              SizedBox(height: appH(16)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: appH(12)),
                margin: EdgeInsets.only(bottom: appH(12)),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyScale.grey200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Loading Lesson Title...',
                    style: AppTextStyles.source.medium(fontSize: 15),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        IconlyLight.time_circle,
                        size: 20,
                        color: AppColors.greyScale.grey600,
                      ),
                      Text(
                        ' 10 daqiqa',
                        style: AppTextStyles.source.medium(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyScale.grey200),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
