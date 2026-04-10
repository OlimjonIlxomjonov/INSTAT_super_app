import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/check_final_test_access/check_final_test_access_entity.dart';

class CheckFinalTestAccessState {
  const CheckFinalTestAccessState();
}

class CheckFinalTestAccessInitial extends CheckFinalTestAccessState {}

class CheckFinalTestAccessLoading extends CheckFinalTestAccessState {}

class CheckFinalTestAccessLoaded extends CheckFinalTestAccessState {
  final CheckFinalTestAccessEntity entity;

  const CheckFinalTestAccessLoaded(this.entity);
}

class CheckFinalTestAccessError extends CheckFinalTestAccessState {}
