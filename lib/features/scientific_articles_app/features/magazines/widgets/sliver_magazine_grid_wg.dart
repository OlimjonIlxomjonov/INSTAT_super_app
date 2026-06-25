import 'package:flutter/material.dart';
import 'package:my_template/core/common/flush_bar/technical_work_flash_bar.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/magazine_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';

class SliverMagazineGridWg extends StatelessWidget {
  final List<ArticleEditionsEntity> items;

  const SliverMagazineGridWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              technicalWorkFlushBar(context, 'Tez orada!');
            },
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 16 / 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child:
                          item.thumbnail != null && item.thumbnail!.isNotEmpty
                          ? Image.network(
                              item.thumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: AppColors.greyScale.grey200,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.greyScale.grey400,
                                    ),
                                  ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: AppColors.greyScale.grey200,
                                    );
                                  },
                            )
                          : Container(
                              color: AppColors.greyScale.grey200,
                              child: Icon(
                                Icons.image,
                                color: AppColors.greyScale.grey400,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(item.title ?? '', style: CustomTextStyles.h3),
                    SizedBox(height: 4),
                    Text(
                      "${item.year}-yil ${item.number}-son",
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
