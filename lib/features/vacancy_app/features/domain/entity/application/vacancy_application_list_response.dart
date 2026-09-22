import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';

class VacancyApplicationListResponse {
  final Links links;
  final List<VacancyApplicationEntity> data;
  final Meta meta;

  const VacancyApplicationListResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
