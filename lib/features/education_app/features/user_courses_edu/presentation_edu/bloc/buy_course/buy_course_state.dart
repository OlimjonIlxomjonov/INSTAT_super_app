import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/order_payment/order_payment_entity.dart';

class BuyCourseState {
  const BuyCourseState();
}

class BuyCourseInitial extends BuyCourseState {}

class BuyCourseLoading extends BuyCourseState {}

class BuyCourseLoaded extends BuyCourseState {
  final OrderPaymentEntity payment;

  const BuyCourseLoaded({required this.payment});
}

class BuyCourseError extends BuyCourseState {
  final String message;

  const BuyCourseError({this.message = 'Something went wrong'});
}
