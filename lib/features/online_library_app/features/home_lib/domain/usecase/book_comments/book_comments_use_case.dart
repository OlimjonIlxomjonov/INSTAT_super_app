import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class BookCommentsUseCase {
  final HomeLibRepository repository;

  BookCommentsUseCase({required this.repository});

  Future<CommentsResponse> call({required OnlineBookCommentsParams params}) {
    return repository.bookComments(params: params);
  }
}
