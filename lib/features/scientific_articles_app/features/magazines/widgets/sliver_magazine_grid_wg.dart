import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/presentation/screens/magazine_detail_page.dart';

class SliverMagazineGridWg extends StatelessWidget {
  final List<ArticleEditionsEntity> items;

  const SliverMagazineGridWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.55,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              openMiniAppSheetFamily(
                context,
                child: MagazineDetailPage(edition: item),
                showHandler: false,
              );
            },
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AspectRatio(
                  aspectRatio: 9 / 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: item.thumbnail != null && item.thumbnail!.isNotEmpty
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
                            loadingBuilder: (context, child, loadingProgress) {
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
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        item.title ?? '',
                        style: CustomTextStyles.h3,
                        maxLines: 2,
                        overflow: .ellipsis,
                      ),
                      Spacer(),
                      Text(
                        localization.yearIssue(
                          item.year ?? '',
                          item.number ?? '',
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
