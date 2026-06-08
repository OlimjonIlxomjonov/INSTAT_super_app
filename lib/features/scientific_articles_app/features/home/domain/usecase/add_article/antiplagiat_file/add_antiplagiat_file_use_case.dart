import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class AddAntiplagiatFileUseCase {
  final ArticlesHomeRepository repository;

  AddAntiplagiatFileUseCase({required this.repository});

  Future<void> call({required AddAntiplagiatFileParams params}) {
    return repository.postAntiplagiatFile(params: params);
  }
}
