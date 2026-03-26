import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_response.dart';

class CourseLessonTopicsState {
  CourseLessonTopicsState();
}

class CourseLessonTopicsInitial extends CourseLessonTopicsState {}

class CourseLessonTopicsLoading extends CourseLessonTopicsState {}

class CourseLessonTopicsLoaded extends CourseLessonTopicsState {
  final CourseLessonTopicsResponse response;

  CourseLessonTopicsLoaded({required this.response});
}

class CourseLessonTopicsError extends CourseLessonTopicsState {}
