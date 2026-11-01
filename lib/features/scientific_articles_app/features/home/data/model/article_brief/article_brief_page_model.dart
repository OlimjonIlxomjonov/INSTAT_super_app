import 'package:my_template/features/scientific_articles_app/features/home/data/model/article_brief/article_brief_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_page_entity.dart';

class ArticleBriefPageModel extends ArticleBriefPageEntity {
  const ArticleBriefPageModel({
    required super.items,
    required super.currentPage,
    required super.total,
    required super.hasMore,
  });

  factory ArticleBriefPageModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] is Map<String, dynamic>
        ? json['meta'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final links = json['links'] is Map<String, dynamic>
        ? json['links'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final items = (json['data'] as List? ?? [])
        .map((e) => ArticleBriefModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final currentPage = (meta['current_page'] as num?)?.toInt() ?? 1;
    final lastPage = (meta['last_page'] as num?)?.toInt() ?? currentPage;

    return ArticleBriefPageModel(
      items: items,
      currentPage: currentPage,
      total: (meta['total'] as num?)?.toInt() ?? items.length,
      hasMore: links['next'] != null || currentPage < lastPage,
    );
  }
}
