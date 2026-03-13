import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/artciles_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/articles_status_check_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/detailed_article_page.dart';

class SliverArticlesListWg extends StatelessWidget {
  final List<ArticlesModel> items;

  const SliverArticlesListWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              openMiniAppSheet(
                context,
                child: DetailedArticlePage(status: item.status),
                showHandler: false,
              );
            },
            child: Container(
              margin: .only(bottom: 12),
              padding: .symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: .circular(16),
                border: .all(color: AppColors.greyScale.grey200),
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "ID: ${item.id}",
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        IconlyLight.calendar,
                        color: AppColors.greyScale.grey400,
                      ),
                      Text(
                        item.date,
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.greyScale.grey400,
                        ),
                      ),
                      Spacer(),
                      ArticlesStatusCheckWg(status: item.status),
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
