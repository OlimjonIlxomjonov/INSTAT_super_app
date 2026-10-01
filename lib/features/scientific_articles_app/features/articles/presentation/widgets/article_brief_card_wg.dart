import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';

class ArticleBriefCardWg extends StatelessWidget {
  final ArticleBriefEntity item;
  final VoidCallback onTap;

  const ArticleBriefCardWg({
    super.key,
    required this.item,
    required this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.source.medium(fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  IconlyLight.calendar,
                  size: 16,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(item.createdAt),
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey500,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  FlutterRemix.double_quotes_l,
                  size: 16,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(width: 2),
                Text(
                  '${item.quotesCount}',
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey500,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  FlutterRemix.download_2_line,
                  size: 16,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(width: 2),
                Text(
                  '${item.downloadCount}',
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey500,
                  ),
                ),
                const Spacer(),
                Text(
                  l.viewArticle,
                  style: AppTextStyles.source.medium(
                    fontSize: 12,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
