import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

class CartState {
  const CartState();
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final BookListResponse response;

  CartLoaded({required this.response});
}

class CartError extends CartState {}
