import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class JournalSectionDdUseCase {
  final ArticlesHomeRepository repository;

  JournalSectionDdUseCase({required this.repository});

  Future<List<DropDownEntity>> call() {
    return repository.getJournalSection();
  }
}
