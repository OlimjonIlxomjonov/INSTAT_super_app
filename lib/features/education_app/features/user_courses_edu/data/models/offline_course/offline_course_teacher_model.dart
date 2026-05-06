import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_teacher_entity.dart';

class OfflineCourseTeacherModel extends OfflineCourseTeacherEntity {
  OfflineCourseTeacherModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.avatar,
  });

  factory OfflineCourseTeacherModel.fromJson(Map<String, dynamic> json) {
    return OfflineCourseTeacherModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}
