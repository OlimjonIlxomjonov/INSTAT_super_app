import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/add_to_cart_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/usercase/cart/cart_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_state.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/user_cart_event.dart';

class CartBloc extends Bloc<UserCartMainEvent, CartState> {
  final CartUseCase useCase;
  final AddToCartUseCase addToCartUseCase;

  CartBloc({required this.useCase, required this.addToCartUseCase})
      : super(CartInitial()) {
    on<CartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final response = await useCase.call();
        emit(CartLoaded(response: response));
      } catch (e) {
        emit(CartError());
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      // Optimistic: immediately remove the item from the current list
      if (state is CartLoaded) {
        final current = (state as CartLoaded).response;
        final updatedList =
            current.data.where((b) => b.id != event.bookId).toList();
        emit(CartLoaded(response: BookListResponse(data: updatedList)));
      }

      try {
        // Toggle-API removes the book from the cart
        await addToCartUseCase.call(event.bookId);
      } catch (_) {
        // On failure, reload from server to restore consistent state
        try {
          final response = await useCase.call();
          emit(CartLoaded(response: response));
        } catch (_) {
          emit(CartError());
        }
      }
    });
  }
}
