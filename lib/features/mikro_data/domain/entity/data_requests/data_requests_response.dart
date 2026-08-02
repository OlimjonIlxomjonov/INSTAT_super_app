import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_entity.dart';

class DataRequestsResponse {
  final Links links;
  final List<DataRequestEntity> data;
  final Meta metaData;

  DataRequestsResponse({
    required this.links,
    required this.data,
    required this.metaData,
  });
}
