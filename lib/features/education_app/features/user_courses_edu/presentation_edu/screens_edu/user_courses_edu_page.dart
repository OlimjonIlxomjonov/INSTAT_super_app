import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';

class UserCoursesEduPage extends StatefulWidget {
  const UserCoursesEduPage({super.key});

  @override
  State<UserCoursesEduPage> createState() => _UserCoursesEduPageState();
}

class _UserCoursesEduPageState extends State<UserCoursesEduPage> {
  CoursesLayout layout = CoursesLayout.grid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(appH(90)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: CustomTabBarWg(
                    firstTab: "Jarayonda",
                    secondTab: "Tugallangan",
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return EduCategoriesWg();
                  }),
                ),
              ),
            ),

            SliverPadding(
              padding: .symmetric(horizontal: appW(20)),
              sliver: SliverToBoxAdapter(
                child: TitleWithLayoutSelectorWg(
                  layout: layout,
                  onChanged: (newLayout) {
                    setState(() {
                      layout = newLayout;
                    });
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: .symmetric(horizontal: appW(20)),
              sliver: SliverToBoxAdapter(
                child: layout == CoursesLayout.grid
                    ? ExpandedCoursesCardWg(
                        onTap: () => openMiniAppSheet(
                          context,
                          child: DetailedUserBoughtCoursesEduPage(),
                        ),
                      )
                    : MinimalCoursesCardWg(
                        onTap: () => openMiniAppSheet(
                          context,
                          child: DetailedUserBoughtCoursesEduPage(),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
