import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class AddCommentUseCase {
  final HomeLibRepository repository;

  AddCommentUseCase({required this.repository});

  Future<void> call({required AddCommentParams params}) {
    return repository.addComment(params: params);
  }
}
