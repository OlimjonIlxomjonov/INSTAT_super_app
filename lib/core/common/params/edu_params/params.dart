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
