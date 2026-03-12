import 'package:my_template/core/utils/enums/app_enums.dart';

class ArticlesModel {
  final String title, id, date;
  final ArticleStatus status;

  ArticlesModel({
    required this.title,
    required this.id,
    required this.date,
    required this.status,
  });
}


