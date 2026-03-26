import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';

class LinksModel extends Links {
  LinksModel({super.next, super.previous});

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(next: json['next'], previous: json['previous']);
  }
}
