import 'package:my_template/core/utils/app_utils.dart';

class LastActionModel {
  final String title;
  final String description;
  final String date;
  final LastActionsStatus status;

  LastActionModel({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });
}
