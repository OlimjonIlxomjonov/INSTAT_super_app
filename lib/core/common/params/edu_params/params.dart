class NoParams {}

class UserCoursesParams {
  final String state; // all or finished

  UserCoursesParams({required this.state});
}

class CourseCategoryByIdParams {
  final int id;

  CourseCategoryByIdParams({required this.id});
}
