import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/features/education_app/features/home_edu/data/repo/home_edu_repo_impl.dart';
import 'package:my_template/features/education_app/features/home_edu/data/source/impl_remote_data_source/home_edu_remote_data_source_impl.dart';
import 'package:my_template/features/education_app/features/home_edu/data/source/remote_data_source/home_edu_remote_data_source.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/comments/comments_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/per_course/per_course_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/repo/leader_board_repo_impl.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/source/impl_remote_data_source/leader_board_remote_data_source_impl.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/source/remote_data_source/leader_board_remote_data_source.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/repository/leader_board_repository.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/usecase/leader_board/leader_board_use_case.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board/leader_board_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/repo/user_courses_repo_impl.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/sources/impl_remote_data_source/user_courses_remote_data_source_impl.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/sources/remote_data_source/user_courses_remote_data_source.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/about_course_features/about_course_features_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/buy_course/buy_course_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/check_final_test_access/check_final_test_access_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course/courses_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_category/course_category_by_id_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_files/course_files_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lesson_items/lessons_items_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lessons_topics/lessons_topics_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/offline_course/offline_course_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_files/course_files_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/main_app/home/data/repo/home_repo_impl.dart';
import 'package:my_template/features/main_app/home/data/source/impl_remote_data_source/home_remote_data_source_impl.dart';
import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';
import 'package:my_template/features/main_app/home/domain/usecase/avatar/avatar_use_case.dart';
import 'package:my_template/features/main_app/home/domain/usecase/courses/courses_use_case.dart';
import 'package:my_template/features/main_app/home/domain/usecase/user_me/user_me_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/search_courses/search_courses_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';

import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/get_lesson_tests_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/get_lesson_test_options_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_lesson_test/submit_lesson_test_answer_usecase.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_bloc.dart';

import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_options_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/submit_final_course_answer_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_final_test/course_final_test_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lesson_video_progress/put_lesson_video_progress_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_bloc.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/repo/offline_books_repo_impl.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/source/impl_remote_data_source/offline_books_remote_data_source_impl.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/source/remote_data_source/offline_books_remote_data_source.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/repository/offline_books_repository.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/usecase/get_offline_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/bloc/offline_books_bloc.dart';

import 'package:my_template/features/education_app/features/table_edu/data/repo/course_group_dates_repo_impl.dart';
import 'package:my_template/features/education_app/features/table_edu/data/source/impl_remote_data_source/course_group_dates_remote_data_source_impl.dart';
import 'package:my_template/features/education_app/features/table_edu/data/source/remote_data_source/course_group_dates_remote_data_source.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/repository/course_group_dates_repository.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/usecase/get_course_group_dates_use_case.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/bloc/course_group_dates_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/repo/home_lib_repo_impl.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/impl_remote_data_source/home_lib_remote_data_source_impl.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/book_websocket_service.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/home_lib_remote_data_source.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/get_popular_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/save_delete_book_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/add_to_cart_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/get_search_books_usecase.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_actions/book_actions_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/search_books/search_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/data/repo/user_cart_repo_impl.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/data/source/impl_remote_data_source/cart_remote_data_source_impl.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/data/source/remote_data_source/cart_remote_data_srouce.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/repository/user_online_book_cart_repository.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/usercase/cart/cart_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/repo/articles_home_repo_impl.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/source/impl_remote_data_source/user_articles_remote_data_source_impl.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/source/remote_data_source/user_articles_remote_data_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/drop_down/academic_degree_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/drop_down/article_type_dd_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/drop_down/journal_section_dd_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/udk/udk_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_editions/article_editions_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_process/article_process_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_file/review_file_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/user_articles/user_articles_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/review_authors_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_detail/review_detail_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/academic_degree/academic_degree_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_section_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_process/article_process_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/create_review_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/update_review_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/create_review_author_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/update_review_author_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';

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
  sl.registerLazySingleton<HomeLibRemoteDataSource>(
    () => HomeLibRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<LeaderBoardRemoteDataSource>(
    () => LeaderBoardRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeEduRemoteDataSource>(
    () => HomeEduRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CourseGroupDatesRemoteDataSource>(
    () => CourseGroupDatesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<OfflineBooksRemoteDataSource>(
    () => OfflineBooksRemoteDataSourceImpl(),
  );

  /// ARTICLES
  sl.registerLazySingleton<UserArticlesRemoteDataSource>(
    () => UserArticlesRemoteDataSourceImpl(),
  );

  /// {REPO}
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserCoursesRepository>(
    () => UserCoursesRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HomeLibRepository>(
    () => HomeLibRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserOnlineBookCartRepository>(
    () => UserCartRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LeaderBoardRepository>(
    () => LeaderBoardRepoImpl(remote: sl()),
  );
  sl.registerLazySingleton<HomeEduRepository>(
    () => HomeEduRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CourseGroupDatesRepository>(
    () => CourseGroupDatesRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<OfflineBooksRepository>(
    () => OfflineBooksRepoImpl(remoteDataSource: sl()),
  );

  /// articles
  sl.registerLazySingleton<ArticlesHomeRepository>(
    () => ArticlesHomeRepoImpl(remoteDataSource: sl()),
  );

  /// {USE CASE}
  sl.registerLazySingleton(() => UserMeUseCase(repository: sl()));
  sl.registerLazySingleton(() => CoursesUseCase(repository: sl()));
  sl.registerLazySingleton(() => CourseCategoryByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => LessonsTopicsUseCase(repository: sl()));
  sl.registerLazySingleton(() => LessonsItemsUseCase(sl()));
  sl.registerLazySingleton(() => ActiveCoursesUseCase(repository: sl()));
  sl.registerLazySingleton(() => AboutCourseFeaturesUseCase(repository: sl()));
  sl.registerLazySingleton(() => CourseFilesUseCase(repository: sl()));
  sl.registerLazySingleton(() => BuyCourseUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchCoursesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetLessonTestsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetLessonTestOptionsUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => SubmitLessonTestAnswerUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => CheckFinalTestAccessUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCourseFinalTestUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetCourseFinalTestOptionsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SubmitFinalCourseAnswerUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => PutLessonVideoProgressUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetPopularBooksUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetSearchBooksUseCase(homeLibRepository: sl()),
  );
  sl.registerLazySingleton(() => BookWebSocketService());
  sl.registerLazySingleton(() => SaveDeleteBookUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => CartUseCase(repository: sl()));
  sl.registerLazySingleton(() => LeaderBoardUseCase(repository: sl()));
  sl.registerLazySingleton(() => AvatarUseCase(repository: sl()));
  sl.registerLazySingleton(() => CommentsUseCase(repository: sl()));
  sl.registerLazySingleton(() => OfflineCourseUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCourseGroupDatesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOfflineBooksUseCase(repository: sl()));
  sl.registerLazySingleton(() => PerCourseUseCase(repository: sl()));
  sl.registerLazySingleton(() => UserArticlesUseCase(repository: sl()));
  sl.registerLazySingleton(() => ReviewAuthorsUseCase(repository: sl()));
  sl.registerLazySingleton(() => ReviewDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => ArticleProcessUseCase(repository: sl()));
  sl.registerLazySingleton(() => ReviewFileUseCase(repository: sl()));
  sl.registerLazySingleton(() => ArticleEditionsUseCase(repository: sl()));
  // add artticle
  sl.registerLazySingleton(() => UdkUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateReviewUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateReviewUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateReviewAuthorUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateReviewAuthorUseCase(repository: sl()));
  //! drop downs
  sl.registerLazySingleton(() => ArticleTypeDdUseCase(repository: sl()));
  sl.registerLazySingleton(() => JournalSectionDdUseCase(repository: sl()));
  sl.registerLazySingleton(() => AcademicDegreeUseCase(repository: sl()));

  /// {BLOC}
  sl.registerLazySingleton(() => UserMeBloc(sl()));
  sl.registerFactory(() => UserCoursesBloc(sl()));
  sl.registerLazySingleton(() => UserCategoryByIdBloc(sl()));
  sl.registerLazySingleton(() => CourseLessonTopicsBloc(sl()));
  sl.registerLazySingleton(() => CourseLessonItemsBloc(sl()));
  sl.registerLazySingleton(() => CoursesBloc(sl()));
  sl.registerLazySingleton(() => AboutCourseFeaturesBloc(sl()));
  sl.registerLazySingleton(() => CourseFilesBloc(sl()));
  sl.registerLazySingleton(() => BuyCourseBloc(useCase: sl()));
  sl.registerFactory(() => SearchCoursesBloc(useCase: sl()));
  sl.registerFactory(
    () => CourseLessonTestBloc(
      getLessonTestsUseCase: sl(),
      getLessonTestOptionsUseCase: sl(),
      submitLessonTestAnswerUseCase: sl(),
    ),
  );
  sl.registerFactory(() => CheckFinalTestAccessBloc(useCase: sl()));
  sl.registerFactory(
    () => CourseFinalTestBloc(
      getCourseFinalTestUseCase: sl(),
      getCourseFinalTestOptionsUseCase: sl(),
      submitFinalCourseAnswerUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => LessonVideoProgressBloc(putLessonVideoProgressUseCase: sl()),
  );
  sl.registerLazySingleton(() => PopularBooksBloc(useCase: sl()));
  sl.registerFactory(() => SearchBooksBloc(useCase: sl()));
  sl.registerLazySingleton(
    () => BookActionsBloc(
      saveDeleteBookUseCase: sl(),
      addToCartUseCase: sl(),
      webSocketService: sl(),
    ),
  );
  sl.registerLazySingleton(() => CartBloc(useCase: sl()));
  sl.registerLazySingleton(() => LeaderBoardBloc(sl()));
  sl.registerLazySingleton(() => AvatarBloc(useCase: sl()));
  sl.registerLazySingleton(() => CommentsBloc(useCase: sl()));
  sl.registerLazySingleton(() => OfflineCourseBloc(useCase: sl()));
  sl.registerFactory(() => CourseGroupDatesBloc(useCase: sl()));
  sl.registerFactory(() => OfflineBooksBloc(getOfflineBooksUseCase: sl()));
  sl.registerFactory(() => PerCourseBloc(useCase: sl()));
  sl.registerFactory(() => UserArticlesBloc(useCase: sl()));
  sl.registerFactory(() => ReviewAuthorsBloc(useCase: sl()));
  sl.registerFactory(() => ReviewDetailBloc(useCase: sl()));
  sl.registerFactory(() => ArticleProcessBloc(useCase: sl()));
  sl.registerFactory(() => ReviewFilesBloc(useCase: sl()));
  sl.registerFactory(() => ArticleEditionsBloc(useCase: sl()));
  // add article
  sl.registerLazySingleton(() => UdkBloc(useCase: sl()));
  sl.registerFactory(
    () => AddArticleBloc(
      createReviewUseCase: sl(),
      updateReviewUseCase: sl(),
      createReviewAuthorUseCase: sl(),
      getReviewAuthorsUseCase: sl(),
    ),
  );
  //! Drop Downs
  sl.registerLazySingleton(() => ArticleTypeBloc(useCase: sl()));
  sl.registerLazySingleton(() => JournalSectionBloc(useCase: sl()));
  sl.registerLazySingleton(() => AcademicDegreeBloc(useCase: sl()));
}
