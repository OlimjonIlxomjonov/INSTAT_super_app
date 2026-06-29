import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';

class UserCommentsWg extends StatelessWidget {
  final CommentsEntity entity;

  const UserCommentsWg({super.key, required this.entity});

  String get formattedDate {
    return DateFormat('dd MMMM yyyy').format(entity.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: .only(left: 20),
      padding: .all(12),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: .circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          ListTile(
            contentPadding: .zero,
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://test.avacoder.uz${entity.user.avatar}',
              ),
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading avatar: $exception');
              },
              child: const Icon(Icons.person),
            ),
            title: Text(
              '${entity.user.firstName} ${entity.user.lastName}',
              maxLines: 1,
              overflow: .ellipsis,
              style: AppTextStyles.source.medium(fontSize: 16),
            ),
            subtitle: Text(
              formattedDate,
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey600,
              ),
            ),
            trailing: TextButton.icon(
              onPressed: null,
              style: TextButton.styleFrom(
                padding: .zero,
                minimumSize: Size(0, 0),
              ),
              iconAlignment: .end,
              icon: Icon(IconlyBold.star, color: AppColors.yellow500),
              label: Text(
                '${entity.stars}',
                style: AppTextStyles.source.medium(
                  fontSize: 15,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: appH(8)),
          Text(
            entity.text,
            maxLines: 4,
            overflow: .ellipsis,
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
          SizedBox(height: appH(10)),
        ],
      ),
    );
  }
}
