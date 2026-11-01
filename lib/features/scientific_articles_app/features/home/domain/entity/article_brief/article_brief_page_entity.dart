import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';

class ArticleBriefPageEntity {
  final List<ArticleBriefEntity> items;
  final int currentPage;
  final int total;
  final bool hasMore;

  const ArticleBriefPageEntity({
    required this.items,
    required this.currentPage,
    required this.total,
    required this.hasMore,
  });
}
