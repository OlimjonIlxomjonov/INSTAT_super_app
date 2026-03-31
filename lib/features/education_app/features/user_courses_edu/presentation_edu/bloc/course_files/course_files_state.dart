import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_files_entity/course_file_entity.dart';

class CourseFilesState {
  CourseFilesState();
}

class CourseFilesInitial extends CourseFilesState {}

class CourseFilesLoading extends CourseFilesState {}

class CourseFilesLoaded extends CourseFilesState {
  final List<CourseFileEntity> entity;

  CourseFilesLoaded({required this.entity});
}

class CourseFilesError extends CourseFilesState {}
