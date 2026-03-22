import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/articles_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/add_article_page.dart';

class UserArticlesPage extends StatelessWidget {
  const UserArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// header
      appBar: CustomAppBarWg(myTitle: 'Mening maqolalarim'),
      body: CustomScrollView(
        slivers: [
          /// search bar
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: const AppSearchbarWg(),
          ),

          /// CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20, top: 10),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return EduCategoriesWg();
                }),
              ),
            ),
          ),

          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Text('Maqolalar', style: CustomTextStyles.h2),
            ),
          ),

          /// USER ARTICLES
          SliverArticlesListWg(items: dummyArticles),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              FamilyNavigation.familyPush(
                context,
                AddArticlePage(),
                showHandle: false,
              );
            },
            icon: Icon(Icons.add),
            label: Text('Maqola qo’shish'),
          ),
        ),
      ),
    );
  }
}
