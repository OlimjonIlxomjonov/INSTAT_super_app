import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_page_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_pages_count_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/library_stats/library_stats_model.dart';

abstract class HomeLibRemoteDataSource {
  Future<BookListResponseModel> fetchPopularBooks({int page = 1});

  Future<void> saveDeleteBook(int id);

  Future<void> addToCart(int id);

  Future<BookListResponseModel> searchBooks(String search, int page);

  //! Book comments
  Future<CommentsResponseModel> fetchBookComments({
    required OnlineBookCommentsParams params,
  });

  //! Add Comment
  Future<void> addComment({required AddCommentParams params});

  //! user books
  Future<BookListResponseModel> fetchUserBooks({int page = 1});

  //! user saved (liked) books
  Future<BookListResponseModel> fetchSavedBooks({int page = 1});

  //! online book reader
  Future<BookPagesCountModel> fetchBookPagesCount(int bookId);

  Future<List<BookPageModel>> fetchBookPages({required BookPagesParams params});

  Future<void> updateBookCurrentPage({
    required UpdateBookCurrentPageParams params,
  });

  Future<LibraryStatsModel> fetchLibraryStats();
}
