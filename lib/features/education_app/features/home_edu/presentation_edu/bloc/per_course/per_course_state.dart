import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class PerCourseState {
  const PerCourseState();
}

class PerCourseInitial extends PerCourseState {}

class PerCourseLoading extends PerCourseState {}

class PerCourseLoaded extends PerCourseState {
  final CourseEntity entity;

  PerCourseLoaded({required this.entity});
}

class PerCourseError extends PerCourseState {}
