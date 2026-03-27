import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/repo/user_courses_repo_impl.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/sources/impl_remote_data_source/user_courses_remote_data_source_impl.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/sources/remote_data_source/user_courses_remote_data_source.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course/courses_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_category/course_category_by_id_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lesson_items/lessons_items_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lessons_topics/lessons_topics_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/main_app/home/data/repo/home_repo_impl.dart';
import 'package:my_template/features/main_app/home/data/source/impl_remote_data_source/home_remote_data_source_impl.dart';
import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';
import 'package:my_template/features/main_app/home/domain/usecase/courses/courses_use_case.dart';
import 'package:my_template/features/main_app/home/domain/usecase/user_me/user_me_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => Dio());

  /// {REMOTE DATA SOURCE}
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UserCoursesRemoteDataSource>(
    () => UserCoursesRemoteDataSourceImpl(),
  );

  /// {REPO}
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserCoursesRepository>(
    () => UserCoursesRepoImpl(remoteDataSource: sl()),
  );

  /// {USE CASE}
  sl.registerLazySingleton(() => UserMeUseCase(repository: sl()));
  sl.registerLazySingleton(() => CoursesUseCase(repository: sl()));
  sl.registerLazySingleton(() => CourseCategoryByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => LessonsTopicsUseCase(repository: sl()));
  sl.registerLazySingleton(() => LessonsItemsUseCase(sl()));
  sl.registerLazySingleton(() => ActiveCoursesUseCase(repository: sl()));

  /// {BLOC}
  sl.registerLazySingleton(() => UserMeBloc(sl()));
  sl.registerLazySingleton(() => UserCoursesBloc(sl()));
  sl.registerLazySingleton(() => UserCategoryByIdBloc(sl()));
  sl.registerLazySingleton(() => CourseLessonTopicsBloc(sl()));
  sl.registerLazySingleton(() => CourseLessonItemsBloc(sl()));
  sl.registerLazySingleton(() => CoursesBloc(sl()));
}
