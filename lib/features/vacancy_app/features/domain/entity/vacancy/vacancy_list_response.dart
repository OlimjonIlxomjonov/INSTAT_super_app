import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';

class VacancyListResponse {
  final Links links;
  final List<VacancyEntity> data;
  final Meta meta;

  const VacancyListResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
