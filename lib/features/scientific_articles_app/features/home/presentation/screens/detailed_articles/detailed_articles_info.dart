import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../../../core/utils/app_utils.dart';
import '../../../../../articles_widgets/detailed_article_body_wg.dart';
import '../../widgets/articles_status_check_wg.dart';

class DetailedArticlesInfo extends StatelessWidget {
  final ArticleStatus status;
  final String createdAt;

  const DetailedArticlesInfo({
    super.key,
    required this.status,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// Article date and status
            Row(
              children: [
                Icon(IconlyLight.calendar, color: AppColors.greyScale.grey600),
                Text(
                  createdAt,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                Spacer(),
                ArticlesStatusCheckWg(status: status),
              ],
            ),
            const SizedBox(height: 8),

            /// ARTICLES INFO
            DetailedArticleBodyWg(),
          ],
        ),
      ),
    );
  }
}
