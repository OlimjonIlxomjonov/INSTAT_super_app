import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class AddReviewFileUseCase {
  final ArticlesHomeRepository repository;

  AddReviewFileUseCase({required this.repository});

  Future<ReviewFilesEntity> call({required AddReviewFileParams params}) {
    return repository.postReviewFile(params: params);
  }
}
