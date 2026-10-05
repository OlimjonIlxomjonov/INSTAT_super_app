import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_group_member/course_group_member_entity.dart';

class CourseGroupMemberModel extends CourseGroupMemberEntity {
  const CourseGroupMemberModel({
    required super.userId,
    required super.attendanceCount,
  });

  factory CourseGroupMemberModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return CourseGroupMemberModel(
      userId: user is Map ? (user['id'] as int? ?? 0) : 0,
      attendanceCount: json['attendance_count'] as int? ?? 0,
    );
  }
}
