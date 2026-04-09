import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/check_final_test_access/check_final_test_access_entity.dart';

class CheckFinalTestAccessModel extends CheckFinalTestAccessEntity {
  CheckFinalTestAccessModel({required super.ok});

  factory CheckFinalTestAccessModel.fromJson(Map<String, dynamic> json) {
    return CheckFinalTestAccessModel(ok: json['ok'] ?? false);
  }
}
