import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/articles_status_check_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/detailed_article_page.dart';


class SliverArticlesListWg extends StatelessWidget {
  final List<UserArticlesEntity> items;

  const SliverArticlesListWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final createdAt = item.createdAt.toString().toReadableDate();
          final updatedAt = item.updatedAt.toString().toReadableDate();
          return GestureDetector(
            onTap: () {
              openMiniAppSheetFamily(
                context,
                child: DetailedArticlePage(
                  reviewId: item.id,
                  status: item.articleStatus,
                ),
                showHandler: false,
                enableDrag: false,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.greyScale.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ID: ${item.id}",
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        IconlyLight.calendar,
                        color: AppColors.greyScale.grey400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        createdAt == updatedAt ? createdAt : updatedAt,
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.greyScale.grey400,
                        ),
                      ),
                      const Spacer(),
                      ArticlesStatusCheckWg(status: item.articleStatus),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
