import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/user_certificate/certificate_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board/leader_board_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_files/course_files_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_actions/book_actions_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/academic_degree/academic_degree_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_section_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/antiplagiat_file/antiplagiat_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/main_file/main_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/upload_review_file/upload_review_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_process/article_process_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';

class MyBlocProvider extends StatelessWidget {
  final Widget child;

  const MyBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserMeBloc>(create: (_) => sl<UserMeBloc>()),
        BlocProvider<UserCoursesBloc>(create: (_) => sl<UserCoursesBloc>()),
        BlocProvider<UserCategoryByIdBloc>(
          create: (_) => sl<UserCategoryByIdBloc>(),
        ),
        BlocProvider<CourseLessonTopicsBloc>(
          create: (_) => sl<CourseLessonTopicsBloc>(),
        ),
        BlocProvider<CourseLessonItemsBloc>(
          create: (_) => sl<CourseLessonItemsBloc>(),
        ),
        BlocProvider<CoursesBloc>(create: (_) => sl<CoursesBloc>()),
        BlocProvider<AboutCourseFeaturesBloc>(
          create: (_) => sl<AboutCourseFeaturesBloc>(),
        ),
        BlocProvider<CourseFilesBloc>(create: (_) => sl<CourseFilesBloc>()),
        BlocProvider<BuyCourseBloc>(create: (_) => sl<BuyCourseBloc>()),
        BlocProvider<CourseFinalTestBloc>(
          create: (_) => sl<CourseFinalTestBloc>(),
        ),
        BlocProvider<LessonVideoProgressBloc>(
          create: (_) => sl<LessonVideoProgressBloc>(),
        ),
        BlocProvider<PopularBooksBloc>(create: (_) => sl<PopularBooksBloc>()),
        BlocProvider<BookActionsBloc>(create: (_) => sl<BookActionsBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
        BlocProvider<LeaderBoardBloc>(create: (_) => sl<LeaderBoardBloc>()),
        BlocProvider<AvatarBloc>(create: (_) => sl<AvatarBloc>()),
        BlocProvider<CommentsBloc>(create: (_) => sl<CommentsBloc>()),
        BlocProvider<OfflineCourseBloc>(create: (_) => sl<OfflineCourseBloc>()),
        BlocProvider<PerCourseBloc>(create: (_) => sl<PerCourseBloc>()),
        BlocProvider<UserArticlesBloc>(create: (_) => sl<UserArticlesBloc>()),
        BlocProvider<ReviewAuthorsBloc>(create: (_) => sl<ReviewAuthorsBloc>()),
        BlocProvider<ReviewDetailBloc>(create: (_) => sl<ReviewDetailBloc>()),
        BlocProvider<ArticleProcessBloc>(
          create: (_) => sl<ArticleProcessBloc>(),
        ),
        BlocProvider<ReviewFilesBloc>(create: (_) => sl<ReviewFilesBloc>()),
        BlocProvider<ArticleEditionsBloc>(
          create: (_) => sl<ArticleEditionsBloc>(),
        ),
        // add article
        BlocProvider<UdkBloc>(create: (_) => sl<UdkBloc>()),
        // AddArticleBloc is provided locally in AddArticlePage (not globally)
        // so that it resets on every new article creation session.
        //! Drop downs
        BlocProvider<ArticleTypeBloc>(create: (_) => sl<ArticleTypeBloc>()),
        BlocProvider<JournalSectionBloc>(
          create: (_) => sl<JournalSectionBloc>(),
        ),
        BlocProvider<AcademicDegreeBloc>(
          create: (_) => sl<AcademicDegreeBloc>(),
        ),
        //! files
        BlocProvider<MainFileBloc>(create: (_) => sl<MainFileBloc>()),
        BlocProvider<AntiplagiatFileBloc>(
          create: (_) => sl<AntiplagiatFileBloc>(),
        ),
        BlocProvider<UploadReviewFileBloc>(
          create: (_) => sl<UploadReviewFileBloc>(),
        ),
        //? User certificate
        BlocProvider<CertificateBloc>(create: (_) => sl<CertificateBloc>()),
      ],
      child: child,
    );
  }
}
