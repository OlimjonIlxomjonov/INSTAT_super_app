import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_files/course_files_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';

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
        BlocProvider<CheckFinalTestAccessBloc>(
          create: (_) => sl<CheckFinalTestAccessBloc>(),
        ),
      ],
      child: child,
    );
  }
}
