class ApiUrls {
  ApiUrls._();

  static const baseUrl = 'https://test.avacoder.uz/api/';

  /// user
  static const me = 'me';

  /// courses
  static const courses = 'courses/';
  static const userCourses = 'courses/items/my/?status=';
  static const userCategoryById = 'categories/';
  static const availableCourses = 'courses/items/active/';

  /// tabs
  static const aboutCourseFeatures = '/course_features/';

  /// lessons topic
  static const lessonsTopic = '/course_blocks/items/all-active/';
  static const lessonItems = '/lessons/items/all-active/';

  /// course test
  static const checkCourseTestAccess = '/test-accessible/';
}
