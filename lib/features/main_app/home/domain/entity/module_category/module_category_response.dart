import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class ModuleCategoryResponse {
  final Links links;
  final List<ModuleCategoryEntity> data;
  final Meta meta;

  ModuleCategoryResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
