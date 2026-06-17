class ApiUrls {
  ApiUrls._();

  static const baseUrl = 'https://test.avacoder.uz/api/';

  /// websocket
  // library
  static const webSocket = 'wss://test.avacoder.uz/ws/books/?token=';

  /// user
  static const me = 'me';

  /// courses
  static const courses = 'courses/';
  static const userCourses = 'courses/items/my/?status=';
  static const userCategoryById = 'categories/';
  static const availableCourses = 'courses/items/active/';

  /// books
  static const activeBooks = 'books/items/active';
  static const offlineBooks = 'books/items/offline/';
  static const bookThumbnail = 'https://test.avacoder.uz/media/';

  // cart
  static const cart = 'books/items/cart/';

  /// tabs
  static const aboutCourseFeatures = '/course_features/';

  /// lessons topic
  static const lessonsTopic = '/course_blocks/items/all-active/';
  static const lessonItems = '/lessons/items/all-active/';

  /// course test
  static const checkCourseTestAccess = '/test-accessible/';

  /// Leader board
  static const leaderBoard = 'courses/students/';

  /// uploadAvatar
  static const uploadAvatar = 'upload-avatar';

  //! comments
  static const userComments = '/comments/active';

  //! offline course
  static const offlineCourse = 'course-groups/list/my/';

  //! course group dates
  static const courseGroups = 'course-groups/';
  static const courseGroupDates = '/course_group_dates/';

  //! ARTICLES
  //? user articles
  static const userArticles = 'reviews/';
  static const reviewAuthors = 'review-authors/';
  static const editions = 'editions/';

  //? add article
  static const udk = 'udk-codes/items/find/?code=';

  //? drop downs
  static const articleType = 'article-types/items/all';
  static const journalSection = 'journal-sections/items/all';
  static const academicDegree = 'academic-degrees/items/all/';

  //? add main file (articles)
  static const mainFileArticle = 'upload-main-file/';
  static const antiplagiatFileArticle = 'upload-antiplagiat-file/';
  static const reviewFilesArticle = 'review-files/';

  //? User certificate
  static const userCertificate = 'courses/certificates/my/';
}
