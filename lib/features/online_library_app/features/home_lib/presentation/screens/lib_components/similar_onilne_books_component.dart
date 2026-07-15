import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

import '../../../../../../../core/utils/constants/api_urls/api_urls.dart';
import '../../../../../../../core/utils/widgets/edu_categories/edu_categories_wg.dart';
import '../../../../../../../core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';

class SimilarOnlineBooksComponent extends StatelessWidget {
  final List<BookEntity> data;

  const SimilarOnlineBooksComponent({super.key, required this.data});

  static const List<Widget> _categories = [
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: AppSearchbarWg(),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          //! CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 20),
              scrollDirection: Axis.horizontal,
              child: Row(children: _categories),
            ),
          ),
          SliverPadding(
            padding: const .only(left: 20, right: 20, bottom: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                localization.books,
                style: AppTextStyles.source.semiBold(fontSize: 17),
              ),
            ),
          ),
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.56,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final book = data[index];
                final thumbnail = book.bookThumbnails.isNotEmpty
                    ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${book.bookThumbnails.first.file}'
                    : '';
                return BookGridItem(
                  id: book.id,
                  isSaved: book.isSaved,
                  type: BookCardType.market,
                  title: book.name,
                  author: book.author.name,
                  price: "${book.price} UZS",
                  imagePath: thumbnail.isNotEmpty
                      ? thumbnail
                      : 'assets/images/temp_book.jpg',
                  onTap: () {
                    openMiniAppSheetFamily(
                      context,
                      showHandler: false,
                      child: DetailedOnlineBookComponent(data: book),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
