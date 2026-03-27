import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/deatiled_course_info_header_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/detailed_course_info_header_image.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/about_this_course_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_comments_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_plan_tab.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_course_features_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';

class DetailedCourseInfoPage extends StatefulWidget {
  final CourseEntity data;
  final String courseCategory;
  final int total;

  const DetailedCourseInfoPage({
    super.key,
    required this.data,
    required this.courseCategory,
    required this.total,
  });

  @override
  State<DetailedCourseInfoPage> createState() => _DetailedCourseInfoPageState();
}

class _DetailedCourseInfoPageState extends State<DetailedCourseInfoPage> {
  void _openPayment(BuildContext context) {
    if (widget.data.userOrder?.status != 'paid') {
      onlineLibStyleCustomBottomSheetWg(
        context,
        headerTitle: "To'lov turi",
        child: const PaymentOpenBottomSheetWg(),
      );
    } else {
      FamilyNavigation.familyPush(
        context,
        DetailedUserBoughtCoursesEduPage(
          data: widget.data,
          categoryName: widget.courseCategory,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AboutCourseFeaturesBloc>().add(
        AboutCourseFeaturesEvent(
          params: CourseCategoryByIdParams(id: widget.data.id),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            DetailedCourseInfoHeaderImage(imagePath: widget.data.thumbnail),
            DetailedCourseInfoHeaderWg(
              data: widget.data,
              categoryName: widget.courseCategory,
            ),
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(appH(90)),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: CustomTabBarWg(
                    firstTab: "Kurs haqida",
                    secondTab: "O'quv reja",
                    thirdTab: "Izohlar",
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              AboutThisCourseTab(
                data: widget.data,
                courseCategory: widget.courseCategory,
                total: widget.total,
              ),
              const CoursePlanTab(),
              const CourseCommentsTab(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavContainerWg(
          onTap: () => _openPayment(context),
          buttonText: widget.data.userOrder!.status == 'paid'
              ? 'Davom etish'
              : 'Sotib olish - ${widget.data.price} UZS',
        ),
      ),
    );
  }
}
