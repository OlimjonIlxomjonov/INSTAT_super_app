import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';

class LessonTestAnswerResponseModel extends LessonTestAnswerResponseEntity {
  LessonTestAnswerResponseModel({
    required super.data,
    required super.isFinished,
    required super.isCorrect,
    required super.ok,
    required super.isRecorded,
    super.matched,
    super.confidenceScore,
  });

  factory LessonTestAnswerResponseModel.fromJson(Map<String, dynamic> json) {
    final ok = json['ok'] as bool? ?? true;
    final rawData = json['data'];
    final hasData = rawData is Map<String, dynamic> && rawData.isNotEmpty;

    return LessonTestAnswerResponseModel(
      data: LessonTestAnswerDataModel.fromJson(hasData ? rawData : {}),
      isFinished: json['is_finished'] ?? false,
      isCorrect: json['is_correct'] ?? false,
      ok: ok,
      isRecorded: ok && hasData,
      matched: json['matched'] as bool?,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
    );
  }
}

class LessonTestAnswerDataModel extends LessonTestAnswerDataEntity {
  LessonTestAnswerDataModel({
    required super.id,
    required super.lessonTest,
    required super.user,
    required super.isCorrect,
    required super.lessonTestOption,
  });

  factory LessonTestAnswerDataModel.fromJson(Map<String, dynamic> json) {
    return LessonTestAnswerDataModel(
      id: json['id'] ?? 0,
      lessonTest: json['lesson_test'] ?? 0,
      user: json['user'] ?? 0,
      isCorrect: json['is_correct'] ?? false,
      lessonTestOption: json['lesson_test_option'] ?? 0,
    );
  }
}
