class ApiUrls {
  ApiUrls._();

  //! base url
  // static const baseUrl = 'https://test.avacoder.uz/api/';
  // static const videoBase = 'https://test.avacoder.uz';

  //! main base url
  static const baseUrl = 'https://api1.instat.uz/api/';
  static const videoBase = 'https://api1.instat.uz';

  //! image base url
  static const imageUrlBase = 'https://api1.instat.uz/media/';

  /// websocket
  //! library // debug
  // static const webSocket = 'wss://test.avacoder.uz/ws/books/?token=';
  //! Production
  static const webSocket = 'wss://api1.instat.uz/ws/books/?token=';

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
  static const addBookComment = '/add-comment/';

  //! offline course
  static const offlineCourse = 'course-groups/list/my/';
  static const offlineLessons = 'lessons';

  //! course group dates
  static const courseGroups = 'course-groups/';
  static const courseGroupDates = '/course_group_dates/';

  //? scan QR
  static const scanQr = 'create-attendance/';

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

  //! Micro Data
  //? Reports
  static const reports = 'data-reports/';

  //! Face Recognition
  static const faceRec = 'my-id/accept';
  static const myIdSession = 'my-id/get-session-id';

  //! buy book
  static const buyBook = 'books/order/';

  //? Similar Courses
  static const similarCourses = 'by-category/';

  //? user books
  static const userBooks = 'books/items/my/';
}
