import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/udk/udk_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/repository/articles_home_repository.dart';

class UdkUseCase {
  final ArticlesHomeRepository repository;

  UdkUseCase({required this.repository});

  Future<UdkEntity> call({required UdkParams params}) {
    return repository.getUdk(params: params);
  }
}
