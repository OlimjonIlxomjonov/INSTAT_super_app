import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/check_final_test_access/check_final_test_access_entity.dart';

class CheckFinalTestState {
  const CheckFinalTestState();
}

class CheckFinalTestInitial extends CheckFinalTestState {}

class CheckFinalTestLoading extends CheckFinalTestState {}

class CheckFinalTestLoaded extends CheckFinalTestState {
  final CheckFinalTestAccessEntity entity;

  CheckFinalTestLoaded({required this.entity});
}

class CheckFinalTestError extends CheckFinalTestState {}
