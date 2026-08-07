import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';

// Date format
String _formatArticleDate(DateTime? date) {
  if (date == null) return '';
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}

class EditionArticleCardWg extends StatelessWidget {
  final EditionArticleEntity item;

  const EditionArticleCardWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final review = item.review;
    final authorNames = review.reviewAuthors
        .map((a) => '${a.firstName} ${a.lastName}'.trim())
        .where((name) => name.isNotEmpty)
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.title,
            style: AppTextStyles.source.medium(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${localization.authors}:',
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey400,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    authorNames.isEmpty ? '...' : authorNames,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                IconlyLight.calendar,
                size: 18,
                color: AppColors.greyScale.grey400,
              ),
              const SizedBox(width: 4),
              Text(
                _formatArticleDate(review.createdAt),
                style: AppTextStyles.source.regular(
                  fontSize: 12,
                  color: AppColors.greyScale.grey400,
                ),
              ),
              const Spacer(),
              Text(
                'ID: #${review.id}',
                style: AppTextStyles.source.regular(
                  fontSize: 12,
                  color: AppColors.greyScale.grey400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
