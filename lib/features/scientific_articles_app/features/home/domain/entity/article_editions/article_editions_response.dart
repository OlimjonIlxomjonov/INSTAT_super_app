import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';

class ArticleEditionsResponse {
  final Links links;
  final Meta meta;
  final List<ArticleEditionsEntity> data;

  ArticleEditionsResponse({
    required this.links,
    required this.meta,
    required this.data,
  });
}
