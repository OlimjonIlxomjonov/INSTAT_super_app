import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class AddMainFileUseCase {
  final ArticlesHomeRepository repository;

  AddMainFileUseCase({required this.repository});

  Future<void> call({required AddMainFileParams params}) {
    return repository.postArticleMainFile(params: params);
  }
}
