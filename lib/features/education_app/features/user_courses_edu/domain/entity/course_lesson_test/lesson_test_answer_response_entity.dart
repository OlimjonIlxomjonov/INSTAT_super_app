class LessonTestAnswerResponseEntity {
  final LessonTestAnswerDataEntity data;
  final bool isFinished;
  final bool isCorrect;

  //! Yuz tekshiruvi
  final bool ok;
  final bool? matched;
  final double? confidenceScore;

  /// Backend javobni faqat yuz tekshiruvidan o'tganda yozadi. O'tmasa
  /// `data` bo'lmaydi va `ok: false` keladi — bu noto'g'ri javob emas,
  /// javob umuman qabul qilinmagan.
  final bool isRecorded;

  LessonTestAnswerResponseEntity({
    required this.data,
    required this.isFinished,
    required this.isCorrect,
    required this.ok,
    required this.isRecorded,
    this.matched,
    this.confidenceScore,
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
