import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/order_payment/order_payment_entity.dart';

class BuyBookState extends Equatable {
  const BuyBookState();

  @override
  List<Object?> get props => [];
}

class BuyBookInitial extends BuyBookState {}

class BuyBookLoading extends BuyBookState {}

class BuyBookLoaded extends BuyBookState {
  final OrderPaymentEntity entity;

  const BuyBookLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class BuyBookError extends BuyBookState {}
