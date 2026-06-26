import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_offline_lessons_entity/course_offline_lessons_entity.dart';

class OfflineLessonsState extends Equatable {
  const OfflineLessonsState();

  @override
  List<Object?> get props => [];
}

class OfflineLessonsInitial extends OfflineLessonsState {}

class OfflineLessonsLoading extends OfflineLessonsState {}

class OfflineLessonsLoaded extends OfflineLessonsState {
  final List<CourseOfflineLessonsEntity> entity;

  const OfflineLessonsLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class OfflineLessonsError extends OfflineLessonsState {}
