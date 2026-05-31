import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_entity.dart';

class UserArticlesResponse {
  final Links links;
  final List<UserArticlesEntity> data;
  final Meta metaData;

  UserArticlesResponse({
    required this.links,
    required this.data,
    required this.metaData,
  });
}
