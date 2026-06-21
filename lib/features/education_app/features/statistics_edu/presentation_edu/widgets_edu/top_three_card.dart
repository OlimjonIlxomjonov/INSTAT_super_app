import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_utils.dart';
import '../../domain/entity/leader_board/leader_board_entity.dart';

/// Renders the top-3 leaderboard users as an Olympic-style podium.
///
/// [items] must contain exactly 3 [LeaderBoardEntity]s in rank order
/// (index 0 = 1st place).
class TopThreePodium extends StatelessWidget {
  final List<LeaderBoardEntity> items;
  final List<String> fullNames;
  final List<String?> thumbnails;
  final void Function(int index) onTap;

  const TopThreePodium({
    super.key,
    required this.items,
    required this.fullNames,
    required this.thumbnails,
    required this.onTap,
  });

  // ── rank colours ──────────────────────────────────────────────
  static const _rankColors = [
    Color(0xFFF6B51E), // 1st – gold
    Color(0xFF9E9E9E), // 2nd – silver
    Color(0xFFCD7F32), // 3rd – bronze
  ];

  // ── Olympic display order: left=2nd, center=1st, right=3rd ────
  static const _displayOrder = [1, 0, 2];

  // indexed by rank: [0]=1st, [1]=2nd, [2]=3rd
  static const _stepHeights = [100.0, 74.0, 58.0]; // tallest → shortest
  static const _avatarRadii = [30.0, 24.0, 22.0]; // biggest → smallest

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.only(top: appH(16), bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final rank in _displayOrder) ...[
            if (rank != _displayOrder.first) SizedBox(width: appW(4)),
            _PodiumColumn(
              rank: rank,
              item: items[rank],
              name: fullNames[rank],
              thumbnail: thumbnails[rank],
              color: _rankColors[rank],
              stepHeight: _stepHeights[rank],
              avatarRadius: _avatarRadii[rank],
              isFirst: rank == 0,
              onTap: () => onTap(rank),
            ),
          ],
        ],
      ),
    );
  }
}

// ── single podium column ──────────────────────────────────────────
class _PodiumColumn extends StatelessWidget {
  final int rank;
  final LeaderBoardEntity item;
  final String name;
  final String? thumbnail;
  final Color color;
  final double stepHeight;
  final double avatarRadius;
  final bool isFirst;
  final VoidCallback onTap;

  const _PodiumColumn({
    required this.rank,
    required this.item,
    required this.name,
    required this.thumbnail,
    required this.color,
    required this.stepHeight,
    required this.avatarRadius,
    required this.isFirst,
    required this.onTap,
  });

  String get _rankLabel => switch (rank) {
    0 => '1',
    1 => '2',
    2 => '3',
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: appW(108),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── avatar ──
            _AvatarRing(
              radius: avatarRadius,
              color: color,
              thumbnail: thumbnail,
              isFirst: isFirst,
            ),
            SizedBox(height: appH(6)),

            // ── name ──
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.source.medium(
                fontSize: isFirst ? 13 : 12,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: appH(3)),

            // ── score with star ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: isFirst ? 14 : 12, color: color),
                SizedBox(width: 3),
                Text(
                  '${item.scoreSum}',
                  style: AppTextStyles.source.semiBold(
                    fontSize: isFirst ? 14 : 12,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: appH(8)),

            // ── podium step with rank number inside ──
            Container(
              height: stepHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(isFirst ? 0.12 : 0.07),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                border: Border.all(
                  color: color.withOpacity(isFirst ? 0.25 : 0.15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _rankLabel,
                    style: AppTextStyles.source.bold(
                      fontSize: isFirst ? 28 : 22,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'O\'rin',
                    style: AppTextStyles.source.regular(
                      fontSize: 10,
                      color: color,
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

// ── avatar ring ────────────────────────────────────────────────
class _AvatarRing extends StatelessWidget {
  final double radius;
  final Color color;
  final String? thumbnail;
  final bool isFirst;

  const _AvatarRing({
    required this.radius,
    required this.color,
    required this.thumbnail,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isFirst ? 3 : 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isFirst
            ? LinearGradient(
                colors: [color, color.withOpacity(0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isFirst ? null : color.withOpacity(0.2),
        boxShadow: isFirst
            ? [
                BoxShadow(
                  color: color.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.greyScale.grey100,
        foregroundImage: thumbnail != null ? NetworkImage(thumbnail!) : null,
        child: thumbnail == null
            ? Icon(
                Icons.person,
                color: AppColors.greyScale.grey500,
                size: radius,
              )
            : null,
      ),
    );
  }
}
