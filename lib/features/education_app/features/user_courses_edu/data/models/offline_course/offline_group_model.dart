import 'package:my_template/features/education_app/features/user_courses_edu/data/models/offline_course/offline_course_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/offline_course/offline_course_teacher_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_group_entity.dart';

class OfflineGroupModel extends OfflineGroupEntity {
  OfflineGroupModel({
    required super.id,
    required super.name,
    required super.course,
    required super.studentsCount,
    required super.teachers,
  });

  factory OfflineGroupModel.fromJson(Map<String, dynamic> json) {
    return OfflineGroupModel(
      id: json['id'] as int,
      name: json['name'] as String,
      course: OfflineCourseModel.fromJson(
        json['course'] as Map<String, dynamic>,
      ),
      studentsCount: json['students_count'] as int,
      teachers: (json['teachers'] as List)
          .map(
            (item) => OfflineCourseTeacherModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
