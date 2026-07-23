import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/book_websocket_service.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/save_delete_book_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/add_to_cart_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/usercase/cart/cart_use_case.dart';

// --- Events ---
abstract class BookActionsEvent {}

class ToggleSaveBookEvent extends BookActionsEvent {
  final int bookId;
  final bool isSaved;
  ToggleSaveBookEvent({required this.bookId, required this.isSaved});
}

class ToggleCartBookEvent extends BookActionsEvent {
  final int bookId;
  final bool isInCart;
  ToggleCartBookEvent({required this.bookId, required this.isInCart});
}

class UpdateBookStateFromSocketEvent extends BookActionsEvent {
  final int bookId;
  final bool? isSaved;
  final bool? isInCart;
  UpdateBookStateFromSocketEvent({required this.bookId, this.isSaved, this.isInCart});
}

class _CartSyncedFromServerEvent extends BookActionsEvent {
  final List<int> cartBookIds;
  _CartSyncedFromServerEvent(this.cartBookIds);
}

// --- States ---
class BookActionsState {
  final Map<int, bool> savedBooks;
  final Map<int, bool> cartBooks;

  BookActionsState({
    this.savedBooks = const {},
    this.cartBooks = const {},
  });

  BookActionsState copyWith({
    Map<int, bool>? savedBooks,
    Map<int, bool>? cartBooks,
  }) {
    return BookActionsState(
      savedBooks: savedBooks ?? this.savedBooks,
      cartBooks: cartBooks ?? this.cartBooks,
    );
  }

  bool isBookSaved(int bookId, {bool defaultValue = false}) {
    return savedBooks[bookId] ?? defaultValue;
  }

  bool isBookInCart(int bookId, {bool defaultValue = false}) {
    return cartBooks[bookId] ?? defaultValue;
  }
}

// --- Bloc ---
class BookActionsBloc extends Bloc<BookActionsEvent, BookActionsState> {
  final SaveDeleteBookUseCase saveDeleteBookUseCase;
  final AddToCartUseCase addToCartUseCase;
  final CartUseCase cartUseCase;
  final BookWebSocketService webSocketService;
  StreamSubscription? _socketSubscription;

  BookActionsBloc({
    required this.saveDeleteBookUseCase,
    required this.addToCartUseCase,
    required this.cartUseCase,
    required this.webSocketService,
  }) : super(BookActionsState()) {
    
    on<ToggleSaveBookEvent>((event, emit) async {
      final updatedMap = Map<int, bool>.from(state.savedBooks);
      updatedMap[event.bookId] = event.isSaved;
      emit(state.copyWith(savedBooks: updatedMap));

      try {
        await saveDeleteBookUseCase.call(event.bookId);
      } catch (e) {
        final revertMap = Map<int, bool>.from(state.savedBooks);
        revertMap[event.bookId] = !event.isSaved;
        emit(state.copyWith(savedBooks: revertMap));
      }
    });

    on<ToggleCartBookEvent>((event, emit) async {
      final updatedMap = Map<int, bool>.from(state.cartBooks);
      updatedMap[event.bookId] = event.isInCart;
      emit(state.copyWith(cartBooks: updatedMap));

      try {
        await addToCartUseCase.call(event.bookId);
      } catch (e) {
        final revertMap = Map<int, bool>.from(state.cartBooks);
        revertMap[event.bookId] = !event.isInCart;
        emit(state.copyWith(cartBooks: revertMap));
      }
    });

    on<UpdateBookStateFromSocketEvent>((event, emit) {
      Map<int, bool>? updatedSavedMap;
      if (event.isSaved != null) {
        updatedSavedMap = Map<int, bool>.from(state.savedBooks);
        updatedSavedMap[event.bookId] = event.isSaved!;
      }

      Map<int, bool>? updatedCartMap;
      if (event.isInCart != null) {
        updatedCartMap = Map<int, bool>.from(state.cartBooks);
        updatedCartMap[event.bookId] = event.isInCart!;
      }
      
      emit(state.copyWith(savedBooks: updatedSavedMap, cartBooks: updatedCartMap));
    });

    on<_CartSyncedFromServerEvent>((event, emit) {
      final updatedMap = Map<int, bool>.from(state.cartBooks);
      for (final id in event.cartBookIds) {
        // Don't clobber anything more recent (an optimistic toggle or a
        // live socket update that already arrived) with this snapshot.
        updatedMap.putIfAbsent(id, () => true);
      }
      emit(state.copyWith(cartBooks: updatedMap));
    });

    _initWebSocket();
    _syncCartFromServer();
  }

  /// The book listing/detail endpoints don't return any "is this in my
  /// cart" field, and the socket only pushes on *change* events (not a
  /// snapshot on connect). Without this, a book added to the cart from the
  /// website (or a previous app session) would look like "not in cart" on
  /// fresh app launch, and the first tap would just toggle the real,
  /// already-true backend state off instead of on.
  Future<void> _syncCartFromServer() async {
    try {
      final cart = await cartUseCase.call();
      if (isClosed) return;
      add(_CartSyncedFromServerEvent(cart.data.map((b) => b.id).toList()));
    } catch (e) {
      // Ignore — falls back to per-book defaults/live socket updates.
    }
  }

  void _initWebSocket() {
    webSocketService.connect();
    _socketSubscription = webSocketService.stream?.listen((message) {
      if (message != null) {
        try {
          final data = jsonDecode(message);
          if (data is Map<String, dynamic> && data['message'] != null) {
            final msg = data['message'];
            if (msg['id'] != null) {
              final int bId = msg['id'];
              
              bool? bSaved;
              if (msg.containsKey('user_book_count')) {
                bSaved = (msg['user_book_count'] ?? 0) >= 1;
              }

              bool? bInCart;
              if (msg.containsKey('in_cart_count')) {
                bInCart = (msg['in_cart_count'] ?? 0) >= 1;
              }

              if (!isClosed && (bSaved != null || bInCart != null)) {
                add(UpdateBookStateFromSocketEvent(bookId: bId, isSaved: bSaved, isInCart: bInCart));
              }
            }
          }
        } catch (e) {
          // Parse error, ignore
        }
      }
    });
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    webSocketService.disconnect();
    return super.close();
  }
}
