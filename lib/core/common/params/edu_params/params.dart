class NoParams {}

class UserCoursesParams {
  final String state; // all or finished

  UserCoursesParams({required this.state});
}

class CourseCategoryByIdParams {
  final int id;

  CourseCategoryByIdParams({required this.id});
}

class CourseLessonItemsParams {
  final int courseId;
  final int blockId;

  CourseLessonItemsParams({required this.courseId, required this.blockId});
}

class CoursesParam {
  CoursesParam();
}

class CourseFilesParams {
  final int courseId, topicId, lessonId;

  CourseFilesParams({
    required this.courseId,
    required this.topicId,
    required this.lessonId,
  });
}

class BuyCourseParams {
  final int courseId;

  BuyCourseParams({required this.courseId});
}

class SearchCoursesParams {
  final String search;
  final int page;

  SearchCoursesParams({required this.search, this.page = 1});
}

class CourseLessonTestParams {
  final int courseId;
  final int blockId;
  final int lessonId;

  CourseLessonTestParams({
    required this.courseId,
    required this.blockId,
    required this.lessonId,
  });
}

class CourseLessonTestOptionsParams {
  final int courseId;
  final int blockId;
  final int lessonId;
  final int testId;

  CourseLessonTestOptionsParams({
    required this.courseId,
    required this.blockId,
    required this.lessonId,
    required this.testId,
  });
}

class SubmitLessonTestAnswerParams {
  final int courseId;
  final int blockId;
  final int lessonId;
  final int testId;
  final int optionId; // Sent as "lesson_test_option" in body

  SubmitLessonTestAnswerParams({
    required this.courseId,
    required this.blockId,
    required this.lessonId,
    required this.testId,
    required this.optionId,
  });
}

class CheckFinalTestAccessParams {
  final int courseId;

  CheckFinalTestAccessParams({required this.courseId});
}

class LessonVideoProgressParams {
  final String lessonId; // or int
  final int progress;

  LessonVideoProgressParams({required this.lessonId, required this.progress});
}
