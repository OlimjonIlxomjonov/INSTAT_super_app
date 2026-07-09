import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/order_payment/order_payment_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class BuyCourseUseCase {
  final UserCoursesRepository repository;

  BuyCourseUseCase({required this.repository});

  Future<OrderPaymentEntity> call({required BuyCourseParams params}) {
    return repository.postBuyCourse(params: params);
  }
}
