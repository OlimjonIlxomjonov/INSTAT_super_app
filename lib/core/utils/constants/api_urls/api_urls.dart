import 'package:my_template/core/common/params/edu_params/params.dart';

class ApiUrls {
  ApiUrls._();

  //! base url
  // static const baseUrl = 'https://test.avacoder.uz/api/';
  // static const videoBase = 'https://test.avacoder.uz';

  //! main base url
  static const baseUrl = 'https://api1.instat.uz/api/';
  static const videoBase = 'https://api1.instat.uz';

  //! image base url
  // static const imageUrlBase = 'https://test.avacoder.uz/media/';
  static const imageUrlBase = 'https://api1.instat.uz/media/';
  static const imageUrlBase2 = 'https://api1.instat.uz/';

  /// websocket
  //! library // debug
  // static const webSocket = 'wss://test.avacoder.uz/ws/books/?token=';
  //! Production
  static const webSocket = 'wss://api1.instat.uz/ws/books/?token=';

  /// user
  static const me = 'me';
  static const token = 'token/';
  static const qrLogin = 'qr-login';

  /// courses
  static const courses = 'courses/';
  static const userCourses = 'courses/items/my/?status=';
  static const userCategoryById = 'categories/';
  static const availableCourses = 'courses/items/active/';

  /// banners
  static const activeBanners = 'banners/items/active/';

  /// books
  static const activeBooks = 'books/items/active/?book_type=online';
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
  static const siteData = 'site-data/items/all/';

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

  //? User data requests
  static const dataRequests = 'data-requests/';

  /// `data-requests/{id}/` ga qo'shiladi
  static const dataRequestUploadFile = 'upload-file/';
  static const dataRequestSend = 'send/';
  static const dataRequestProcesses = 'processes/';

  //? Add request dropdowns
  static const microDataCategories = 'categories/items/all/?type=micro-data';
  static const regions = 'regions/';

  //! Face Recognition
  static const faceRec = 'my-id/accept';
  static const myIdSession = 'my-id/get-session-id';

  //! buy book
  static const buyBook = 'books/order/';

  //? Similar Courses
  static const similarCourses = 'by-category/';

  //? user books
  static const userBooks = 'books/items/my/';

  //? saved (liked) books
  static const savedBooks = 'books/items/saved/';

  //? online book reader — page images require auth, unlike plain /media/ files
  static String bookPageImageUrl(int pageId) => '${baseUrl}book-pages/$pageId';

  //! Not-resident (foreign user) account confirmation
  static const countriesList = 'countries/items/all/';
  static const registerNotResident = 'register-not-resident';

  //? Report files
  static String reportFiles(int reportId) => 'data-reports/$reportId/files/';

  static String reportVariables(int reportId) =>
      'data-reports/$reportId/variables/';

  //? Notifications
  static const String notif = 'notifications/?page=';
  static const String notifCount = 'notifications/items/unread-count/';

  //? Active Devices // DELETE TOO
  static const String activeDevices = 'devices';

  //! Tickets
  static String showTickets(String status, String search, String page) =>
      'tickets/?status=$status&search=$search&page=$page';

  static String showTicketChat(TicketsChatParams params) =>
      'tickets/${params.ticketId}/messages/';

  static String sendMessage(SendMessageParams params) =>
      'tickets/${params.ticketId}/send-message/';
  static const String createTicket = 'tickets/';
  static const String deleteTicket = 'tickets/';

  //? Review process
  static String reviewProcess(String reviewType) =>
      '$reviewType/items/all-processes';

  //? Module Categories
  static String moduleCategories(String type, String page) =>
      'categories/?type=$type&page=$page';

  //?  Stats Count
  static const String itemCount = '/items/count/';

  //library
  static const String libraryStats = 'books$itemCount';

  //! site FAQs
  static const String siteFaqs = 'site-faqs/items/all/?module=';
}
