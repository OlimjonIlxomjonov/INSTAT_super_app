import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class OfflineBooksLibPage extends StatelessWidget {
  const OfflineBooksLibPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Kutubxona'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            title: AppSearchbarWg(),
            toolbarHeight: 80,
          ),

          /// CATEGORIES
          SliverPadding(
            padding: .symmetric(vertical: 10),
            sliver: SliverToBoxAdapter(
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
          ),
          SliverPadding(
            padding: .only(left: 20),
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
              padding: AppPadding.hAndV20x20(),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.51,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return BookGridItem(
                    type: BookCardType.library,
                    title: "Jajji shahzoda",
                    author: "Antuan de Sent-Ekzyuperi",
                    shelfNumber: 1,
                    rowNumber: 12,
                    imagePath: 'assets/images/temp_book.jpg',
                    onTap: () {
                      // openMiniAppSheetFamily(
                      //   context,
                      //   child: DetailedOnlineBookComponent(
                      //     isBookBought: true,
                      //     isOffline: true,
                      //   ),
                      // );
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
