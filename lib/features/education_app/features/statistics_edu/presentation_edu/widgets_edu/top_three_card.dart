import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_utils.dart';
import '../../domain/entity/leader_board/leader_board_entity.dart';

class TopThreeCard extends StatelessWidget {
  final int index;
  final LeaderBoardEntity item;
  final String fullName;
  final String? thumbnail;
  final VoidCallback onTap;

  const TopThreeCard({
    required this.index,
    required this.item,
    required this.fullName,
    required this.thumbnail,
    required this.onTap,
  });

  static const _medals = ['🥇', '🥈', '🥉'];

  static const _gradients = [
    [Color(0xFFFFF8DC), Color(0xFFFFD700)], // Gold
    [Color(0xFFF5F5F5), Color(0xFFC0C0C0)], // Silver
    [Color(0xFFFFF0E8), Color(0xFFCD7F32)], // Bronze
  ];

  static const _borderColors = [
    Color(0xFFFFD700),
    Color(0xFFC0C0C0),
    Color(0xFFCD7F32),
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = _gradients[index];
    final borderColor = _borderColors[index];
    final avatarRadius = index == 0 ? 36.0 : 28.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: appH(12)),
        padding: EdgeInsets.symmetric(horizontal: appW(14), vertical: appH(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [gradient[0], gradient[1].withOpacity(0.25)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: borderColor.withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Medal + rank label stacked
            SizedBox(
              width: 40,
              child: Text(
                _medals[index],
                style: TextStyle(fontSize: index == 0 ? 28 : 22),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: CircleAvatar(
                radius: avatarRadius,
                foregroundImage: thumbnail != null
                    ? NetworkImage(thumbnail!)
                    : null,
                child: thumbnail == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.greyScale.grey800,
                        size: avatarRadius,
                      )
                    : null,
              ),
            ),
            SizedBox(width: 12),
            // Name + email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.medium(
                      fontSize: index == 0 ? 15 : 14,
                    ),
                  ),
                  Text(
                    item.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.regular(
                      fontSize: 11,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: appW(8)),

            // Score chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, size: 16, color: borderColor),
                  const SizedBox(width: 3),
                  Text(
                    item.scoreSum.toString(),
                    style: AppTextStyles.source.medium(
                      fontSize: 13,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
