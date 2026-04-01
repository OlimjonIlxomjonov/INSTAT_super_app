import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';

class UserCategoryByIdState {
  final Map<int, CourseCategoryByIdEntity> categories;

  UserCategoryByIdState({this.categories = const {}});
}

class UserCategoryByIdInitial extends UserCategoryByIdState {
  UserCategoryByIdInitial() : super(categories: {});
}

class UserCategoryByIdLoading extends UserCategoryByIdState {
  UserCategoryByIdLoading({required super.categories});
}

class UserCategoryByIdLoaded extends UserCategoryByIdState {
  final CourseCategoryByIdEntity entity;

  UserCategoryByIdLoaded({required this.entity, required super.categories});
}

class UserCategoryByIdError extends UserCategoryByIdState {
  UserCategoryByIdError({required super.categories});
}
