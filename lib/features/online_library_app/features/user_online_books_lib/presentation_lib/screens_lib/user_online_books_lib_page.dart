import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class UserOnlineBooksLibPage extends StatelessWidget {
  const UserOnlineBooksLibPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: CustomTabBarWg(
              firstTab: "Jarayonda",
              secondTab: "Tugallangan",
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar(
            //   pinned: false,
            //   floating: true,
            //   backgroundColor: AppColors.white,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   toolbarHeight: 0,
            //   bottom: PreferredSize(
            //     preferredSize: Size.fromHeight(90),
            //     child: Padding(
            //       padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            //       child: CustomTabBarWg(
            //         firstTab: "Jarayonda",
            //         secondTab: "Tugallangan",
            //       ),
            //     ),
            //   ),
            // ),
            SliverAppBar(
              primary: false,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              title: AppSearchbarWg(),
              toolbarHeight: 80,
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(right: 20, top: 20),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return EduCategoriesWg();
                  }),
                ),
              ),
            ),

            SliverPadding(
              padding: .only(left: 20, top: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Kitoblarim',
                  style: AppTextStyles.source.semiBold(fontSize: 17),
                ),
              ),
            ),
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.53,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return BookGridItem(
                    type: BookCardType.bought,
                    title: "Jajji shahzoda",
                    author: "Antuan de Sent-Ekzyuperi",
                    progress: 0.75,
                    currentPage: 122,
                    totalPages: 354,
                    imagePath: 'assets/images/temp_book.jpg',
                    onTap: () {
                      openMiniAppSheetFamily(
                        context,
                        child: DetailedOnlineBookComponent(isBookBought: true),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
