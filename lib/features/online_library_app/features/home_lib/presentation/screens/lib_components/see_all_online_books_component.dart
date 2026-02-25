import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class SeeAllOnlineBooksComponent extends StatelessWidget {
  const SeeAllOnlineBooksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Kitoblar'),
          SliverPadding(
            padding: .symmetric(horizontal: appW(20), vertical: appH(10)),
            sliver: SliverAppBar(
              toolbarHeight: appH(56) + appH(24),
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: AppSearchbarWg(),
            ),
          ),

          /// CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20, bottom: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return EduCategoriesWg();
                }),
              ),
            ),
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Kitoblar',
                style: AppTextStyles.source.semiBold(fontSize: 17),
              ),
            ),
          ),

          /// BODY
          SliverSafeArea(
            sliver: SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.56,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return BookGridItem(
                    imagePath: 'assets/images/temp_book.jpg',
                    rating: 4.5,
                    author: 'Antuan de Sent-Ekzyuperi',
                    title: 'Jajji shahzoda',
                    price: '300 000 UZS',
                    oldPrice: '330 000 UZS',
                    isBoughtBook: false,
                    onTap: () {
                      openMiniAppSheetFamily(
                        context,
                        child: DetailedOnlineBookComponent(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
