import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_teacher_entity.dart';

class OfflineGroupEntity {
  final int id;
  final String name;
  final OfflineCourseEntity course;
  final int studentsCount;
  final List<OfflineCourseTeacherEntity> teachers;

  OfflineGroupEntity({
    required this.id,
    required this.name,
    required this.course,
    required this.studentsCount,
    required this.teachers,
  });


}
