import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class SimilarOnlineBooksComponent extends StatelessWidget {
  const SimilarOnlineBooksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(isFamily: true, myTitle: 'O\'xshash kitoblar'),
          SliverAppBar(
            primary: false,
            pinned: true,
            automaticallyImplyLeading: false,
            title: AppSearchbarWg(),
            toolbarHeight: 80,
          ),

          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Kitoblar',
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
              itemCount: 6,
              itemBuilder: (context, index) {
                return BookGridItem(
                  type: BookCardType.market,
                  title: "Jajji shahzoda",
                  author: "Antuan de Sent-Ekzyuperi",
                  rating: 4.5,
                  price: "300 000 UZS",
                  oldPrice: "330 000 UZS",
                  imagePath: 'assets/images/temp_book.jpg',
                  onTap: () {
                    // FamilyNavigation.familyPush(
                    //   context,
                    //   DetailedOnlineBookComponent(),
                    // );
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
