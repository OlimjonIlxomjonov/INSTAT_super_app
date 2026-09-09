import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class VacancyCommissionMemberWg extends StatelessWidget {
  final String name;
  final String phone;
  final String? avatarUrl;

  const VacancyCommissionMemberWg({
    super.key,
    required this.name,
    required this.phone,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.greyScale.grey200,
            backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
            child: hasAvatar
                ? null
                : Icon(
                    FlutterRemix.user_line,
                    size: 20,
                    color: AppColors.greyScale.grey500,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.source.medium(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: AppTextStyles.source.regular(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
