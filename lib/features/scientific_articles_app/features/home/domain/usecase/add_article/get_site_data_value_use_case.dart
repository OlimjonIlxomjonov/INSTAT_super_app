import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class GetSiteDataValueUseCase {
  final ArticlesHomeRepository repository;

  GetSiteDataValueUseCase({required this.repository});

  Future<String?> call({required String key}) {
    return repository.getSiteDataValue(key: key);
  }
}
