import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class MetaModel extends Meta {
  MetaModel({
    required super.total,
    required super.perPage,
    required super.currentPage,
    required super.from,
    required super.to,
    required super.lastPage,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      from: json['from'],
      to: json['to'],
      lastPage: json['last_page'],
    );
  }
}
