import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class SimilarCoursesState extends Equatable {
  const SimilarCoursesState();

  @override
  List<Object?> get props => [];
}

class SimilarCoursesInitial extends SimilarCoursesState {}

class SimilarCoursesLoading extends SimilarCoursesState {}

class SimilarCoursesLoaded extends SimilarCoursesState {
  final List<CourseEntity> listEntity;

  const SimilarCoursesLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class SimilarCoursesError extends SimilarCoursesState {}
