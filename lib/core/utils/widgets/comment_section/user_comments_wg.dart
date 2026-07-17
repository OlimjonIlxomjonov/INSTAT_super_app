import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';

import '../../logger/logger.dart';

class UserCommentsWg extends StatelessWidget {
  final CommentsEntity entity;
  final bool showAll;

  const UserCommentsWg({super.key, required this.entity, this.showAll = false});

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
              backgroundColor: AppColors.greyScale.grey300,
              backgroundImage: NetworkImage(
                'https://test.avacoder.uz${entity.user.avatar}',
              ),
              onBackgroundImageError: (exception, stackTrace) {
                logger.e('Error loading avatar: $exception');
              },
              child: entity.user.avatar == null
                  ? Icon(Icons.person, color: AppColors.greyScale.grey600)
                  : null,
              // child: Icon(Icons.person, color: AppColors.greyScale.grey600),
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
          const SizedBox(height: 8),
          Text(
            entity.text,
            maxLines: showAll ? null : 5,
            overflow: showAll ? null : .ellipsis,
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
