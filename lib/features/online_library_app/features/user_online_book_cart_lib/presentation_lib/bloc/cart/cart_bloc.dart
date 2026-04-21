import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/usercase/cart/cart_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_state.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/user_cart_event.dart';

class CartBloc extends Bloc<UserCartMainEvent, CartState> {
  final CartUseCase useCase;

  CartBloc({required this.useCase}) : super(CartInitial()) {
    on<CartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final response = await useCase.call();
        emit(CartLoaded(response: response));
      } catch (e) {
        emit(CartError());
      }
    });
  }
}
