import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/lesson_status/lesson_status_entity.dart';

class LessonStatusModel extends LessonStatusEntity {
  const LessonStatusModel({
    required super.isFaceIdEnabled,
    required super.userProgress,
  });

  factory LessonStatusModel.fromJson(Map<String, dynamic> json) {
    return LessonStatusModel(
      isFaceIdEnabled: json['is_face_id_enabled'] == true,
      userProgress: (json['user_progress'] as num?)?.toDouble() ?? 0,
    );
  }
}
