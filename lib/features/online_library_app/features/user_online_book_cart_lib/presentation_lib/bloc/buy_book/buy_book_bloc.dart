import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/usercase/buy_book/buy_book_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/buy_book/buy_book_state.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/user_cart_event.dart';

class BuyBookBloc extends Bloc<UserCartMainEvent, BuyBookState> {
  final BuyBookUseCase useCase;

  BuyBookBloc({required this.useCase}) : super(BuyBookInitial()) {
    on<BuyBookEvent>((event, emit) async {
      emit(BuyBookLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(BuyBookLoaded(entity: entity));
      } catch (e) {
        emit(BuyBookError());
      }
    });
  }
}
