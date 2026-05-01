import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class CommentsUseCase {
  final HomeEduRepository repository;

  CommentsUseCase({required this.repository});

  Future<CommentsResponse> call({required CommentsParams params}) {
    return repository.getComments(params: params);
  }
}
