import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';

class DataRequestsResponseModel extends DataRequestsResponse {
  DataRequestsResponseModel({
    required super.links,
    required super.data,
    required super.metaData,
  });

  factory DataRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    return DataRequestsResponseModel(
      links: LinksModel.fromJson(
        (json['links'] as Map<String, dynamic>?) ?? const {},
      ),
      data:
          (json['data'] as List?)
              ?.map((e) => DataRequestModel.fromJson(e))
              .toList() ??
          [],
      metaData: _metaFromJson(json['meta'] as Map<String, dynamic>?),
    );
  }

  /// MetaModel.fromJson barcha maydonlarni non-null int deb kutadi, lekin
  /// natija bo'sh bo'lganda backend `from`/`to` ni null qilib qaytaradi.
  /// Shunda parsing yiqilib, bo'sh holat o'rniga xato ekrani chiqib qolardi.
  static MetaModel _metaFromJson(Map<String, dynamic>? json) {
    return MetaModel(
      total: json?['total'] ?? 0,
      perPage: json?['per_page'] ?? 0,
      currentPage: json?['current_page'] ?? 1,
      from: json?['from'] ?? 0,
      to: json?['to'] ?? 0,
      lastPage: json?['last_page'] ?? 1,
    );
  }
}
