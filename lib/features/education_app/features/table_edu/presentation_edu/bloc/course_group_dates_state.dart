import 'package:my_template/features/education_app/features/table_edu/domain/entity/course_group_date_entity.dart';

abstract class CourseGroupDatesState {
  const CourseGroupDatesState();
}

class CourseGroupDatesInitial extends CourseGroupDatesState {}

class CourseGroupDatesLoading extends CourseGroupDatesState {}

class CourseGroupDatesLoaded extends CourseGroupDatesState {
  final List<CourseGroupDateEntity> dates;

  const CourseGroupDatesLoaded({required this.dates});

  Set<DateTime> get markedDates =>
      dates.map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day)).toSet();
}

class CourseGroupDatesError extends CourseGroupDatesState {
  final String message;

  const CourseGroupDatesError({required this.message});
}
