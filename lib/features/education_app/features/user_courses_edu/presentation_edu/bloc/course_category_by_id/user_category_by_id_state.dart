import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';

class UserCategoryByIdState {
  UserCategoryByIdState();
}

class UserCategoryByIdInitial extends UserCategoryByIdState {}

class UserCategoryByIdLoading extends UserCategoryByIdState {}

class UserCategoryByIdLoaded extends UserCategoryByIdState {
  final CourseCategoryByIdEntity entity;

  UserCategoryByIdLoaded({required this.entity});
}

class UserCategoryByIdError extends UserCategoryByIdState {}
