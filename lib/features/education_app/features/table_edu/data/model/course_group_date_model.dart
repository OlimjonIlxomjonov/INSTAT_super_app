import 'package:my_template/features/education_app/features/table_edu/domain/entity/course_group_date_entity.dart';

class CourseGroupDateModel extends CourseGroupDateEntity {
  const CourseGroupDateModel({
    required super.id,
    required super.courseGroup,
    required super.dateTime,
    required super.lessonsCount,
    required super.attendanceCount,
  });

  factory CourseGroupDateModel.fromJson(Map<String, dynamic> json) {
    return CourseGroupDateModel(
      id: json['id'] as int,
      courseGroup: json['course_group'] as int,
      dateTime: DateTime.parse(json['date_time'] as String),
      lessonsCount: json['lessons_count'] as int,
      attendanceCount: json['attendance_count'] as int,
    );
  }
}
