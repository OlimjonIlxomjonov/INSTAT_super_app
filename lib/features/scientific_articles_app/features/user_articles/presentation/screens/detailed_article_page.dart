import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/features/scientific_articles_app/articles_widgets/detailed_article_body_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/last_actions_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/articles_status_check_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/sliver_last_actions_wg.dart';

class DetailedArticlePage extends StatefulWidget {
  final ArticleStatus status;

  const DetailedArticlePage({super.key, required this.status});

  @override
  State<DetailedArticlePage> createState() => _DetailedArticlePageState();
}

class _DetailedArticlePageState extends State<DetailedArticlePage> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Maqola tafsilotlari'),

          /// CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(2, (index) {
                  return EduCategoriesWg(
                    isSelected: selectedCategory == index,
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  );
                }),
              ),
            ),
          ),

          if (selectedCategory == 0) ...[
            /// ARTICLES INFO
            SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    /// Article date and status
                    Row(
                      children: [
                        Icon(
                          IconlyLight.calendar,
                          color: AppColors.greyScale.grey600,
                        ),
                        Text(
                          '19.02.2025',
                          style: AppTextStyles.source.regular(
                            fontSize: 12,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                        Spacer(),
                        ArticlesStatusCheckWg(status: widget.status),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /// ARTICLES INFO
                    DetailedArticleBodyWg(),
                  ],
                ),
              ),
            ),
          ] else ...[
            /// ARTICLES ACTIONS
            SliverPadding(
              padding: .only(left: 20, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Text('2-tsikl', style: CustomTextStyles.h2),
              ),
            ),
            SliverLastActionsWg(items: lastActions),
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: Text('1-tsikl', style: CustomTextStyles.h2),
              ),
            ),
            SliverLastActionsWg(items: lastActions),
          ],
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        leadingIcon: IconlyLight.edit,
        buttonText: 'Tahrirlash',
        onTap: () {},
      ),
    );
  }
}
