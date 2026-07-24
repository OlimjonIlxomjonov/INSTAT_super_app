import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_page_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_pages_count_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/home_lib_remote_data_source.dart';

class HomeLibRemoteDataSourceImpl implements HomeLibRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<BookListResponseModel> fetchPopularBooks() async {
    try {
      final response = await _dioClient.get(ApiUrls.activeBooks);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return BookListResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> saveDeleteBook(int id) async {
    try {
      final response = await _dioClient.post('books/$id/save-delete-book/');
      if (response.statusCode != 204 &&
          response.statusCode != 200 &&
          response.statusCode != 201) {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> addToCart(int id) async {
    try {
      final response = await _dioClient.post('books/$id/add-to-cart/');
      if (response.statusCode != 204 &&
          response.statusCode != 200 &&
          response.statusCode != 201) {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<BookListResponseModel> searchBooks(String search, int page) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.activeBooks,
        queryParams: {'search': search, 'page': page},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return BookListResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  //! Book comments
  @override
  Future<CommentsResponseModel> fetchBookComments({
    required OnlineBookCommentsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        'books/${params.bookId}/comments/?id=${params.bookId}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CommentsResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  //! Add Comment
  @override
  Future<void> addComment({required AddCommentParams params}) async {
    try {
      final response = await _dioClient.post(
        "books/${params.bookId}${ApiUrls.addBookComment}",
        data: {"stars": params.stars, "text": params.bookDesc},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<BookListResponseModel> fetchUserBooks() async {
    try {
      final response = await _dioClient.get(ApiUrls.userBooks);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return BookListResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<BookPagesCountModel> fetchBookPagesCount(int bookId) async {
    try {
      final response = await _dioClient.get(
        'books/$bookId/pages-count/',
        queryParams: {'book_id': bookId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return BookPagesCountModel.fromJson(response.data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<BookPageModel>> fetchBookPages({
    required BookPagesParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        'books/${params.bookId}/pages/',
        queryParams: {
          'book_id': params.bookId,
          'page_number': params.pageNumber,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => BookPageModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> updateBookCurrentPage({
    required UpdateBookCurrentPageParams params,
  }) async {
    try {
      // book_id is sent as a string here to match the exact shape the
      // website already sends — the backend may be strict about it.
      final response = await _dioClient.post(
        'books/${params.bookId}/current-page/',
        data: {
          'book_id': params.bookId.toString(),
          'current_page': params.currentPage,
        },
      );
      logger.i(response.data);
    } catch (e) {
      // Fire-and-forget: never let a failed progress update disrupt reading.
      logger.e(e);
    }
  }
}
