class LessonTestAnswerResponseEntity {
  final LessonTestAnswerDataEntity data;
  final bool isFinished;
  final bool isCorrect;

  LessonTestAnswerResponseEntity({
    required this.data,
    required this.isFinished,
    required this.isCorrect,
  });
}

class LessonTestAnswerDataEntity {
  final int id;
  final int lessonTest;
  final int user;
  final bool isCorrect;
  final int lessonTestOption;

  LessonTestAnswerDataEntity({
    required this.id,
    required this.lessonTest,
    required this.user,
    required this.isCorrect,
    required this.lessonTestOption,
  });
}
