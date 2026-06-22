import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';

class ReportsResponse {
  final Links links;
  final List<ReportsEntity> data;
  final Meta meta;

  const ReportsResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
