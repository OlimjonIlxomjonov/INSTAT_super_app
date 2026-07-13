import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/deatiled_course_info_header_wg.dart';
import 'package:my_template/core/utils/widgets/detailed_course_info_header/detailed_course_info_header_image.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_state.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/about_this_course_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_comments_tab.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/course_plan_tab.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _DetailedCourseInfoPageState extends State<DetailedCourseInfoPage>
    with SingleTickerProviderStateMixin {
  late final List<Widget> _headerSlivers;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });

    logger.f("rating count: ${widget.data.ratingsCount}");
    logger.f("desc: ${widget.data.descriptionUz}");

    _headerSlivers = [
      // image header
      DetailedCourseInfoHeaderImage(imagePath: widget.data.thumbnail),
      // course title and brief info till "Izoh"
      DetailedCourseInfoHeaderWg(
        data: widget.data,
        categoryName: widget.courseCategory,
      ),

      /// course tabs
      SliverAppBar(
        pinned: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: CustomTabBarWg(
              controller: _tabController,
              firstTab: "Kurs haqida",
              secondTab: "O'quv reja",
              thirdTab: "Izohlar",
            ),
          ),
        ),
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AboutCourseFeaturesBloc>().add(
        AboutCourseFeaturesEvent(
          params: CourseCategoryByIdParams(id: widget.data.id),
        ),
      );
      context.read<CourseLessonTopicsBloc>().add(
        CourseLessonTopicsEvent(
          params: CourseCategoryByIdParams(id: widget.data.id),
        ),
      );
      context.read<CommentsBloc>().add(
        CommentsEvent(params: CommentsParams(courseId: widget.data.id)),
      );
      context.read<PerCourseBloc>().add(
        PerCourseEvent(params: PerCourseParams(courseId: widget.data.id)),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final perCourse = context.watch<PerCourseBloc>().state;
    final item = perCourse is PerCourseLoaded ? perCourse.entity : null;
    final isLoading = perCourse is PerCourseLoading;
    final status = _paymentStatus(item?.userOrder?.status);

    return BlocListener<BuyCourseBloc, BuyCourseState>(
      listener: (context, state) {
        if (state is BuyCourseLoaded) {
          _openPaymentUrl(state.payment.redirectUrl, context);
          context.read<PerCourseBloc>().add(
            PerCourseEvent(params: PerCourseParams(courseId: widget.data.id)),
          );
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            ..._headerSlivers,
            SliverToBoxAdapter(child: _buildTabContent()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
        bottomNavigationBar: Skeletonizer(
          enabled: isLoading,
          child: AbsorbPointer(
            absorbing: status == PaymentStatusEnum.pending,
            child: Opacity(
              opacity: status == PaymentStatusEnum.pending ? 0.5 : 1.0,
              child: CustomBottomNavContainerWg(
                onTap: () => _handleBottomNavTap(context, status),
                buttonText: _buttonTextFor(status),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabController.index) {
      case 0:
        return AboutThisCourseTab(
          data: widget.data,
          courseCategory: widget.courseCategory,
          total: widget.total,
        );
      case 1:
        return const CoursePlanTab();
      default:
        return CourseCommentsTab();
    }
  }

  void _handleBottomNavTap(BuildContext context, PaymentStatusEnum status) {
    switch (status) {
      case PaymentStatusEnum.paid:
        FamilyNavigation.familyPush(
          showHandle: false,
          context,
          DetailedUserBoughtCoursesEduPage(
            data: widget.data,
            categoryName: widget.courseCategory,
          ),
        );
        break;
      case PaymentStatusEnum.pending:
        break; // no-op, matches original `null`
      case PaymentStatusEnum.notBought:
        onlineLibStyleCustomBottomSheetWg(
          context,
          headerTitle: "To'lov turi",
          child: PaymentOpenBottomSheetWg(courseId: widget.data.id),
        );
        break;
    }
  }

  String _buttonTextFor(PaymentStatusEnum status) {
    switch (status) {
      case PaymentStatusEnum.paid:
        return 'Davom etish';
      case PaymentStatusEnum.pending:
        return 'Ko‘rib chiqilmoqda';
      case PaymentStatusEnum.notBought:
        return "Sotib olish - ${widget.data.price} UZS";
    }
  }

  PaymentStatusEnum _paymentStatus(String? orderStatus) {
    switch (orderStatus) {
      case 'paid':
        return PaymentStatusEnum.paid;
      case 'pending':
        return PaymentStatusEnum.notBought;
      default:
        return PaymentStatusEnum.notBought;
    }
  }

  Future<void> _openPaymentUrl(String url, BuildContext context) async {
    try {
      logger.i('Opening payment URL: $url');
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      logger.i('URL launched successfully');
    } catch (e) {
      logger.e('Failed to open payment URL: $e');
    }
  }
}
