import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/book_websocket_service.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/save_delete_book_use_case.dart';

// --- Events ---
abstract class BookActionsEvent {}

class ToggleSaveBookEvent extends BookActionsEvent {
  final int bookId;
  final bool isSaved;
  ToggleSaveBookEvent({required this.bookId, required this.isSaved});
}

class UpdateBookStateFromSocketEvent extends BookActionsEvent {
  final int bookId;
  final bool isSaved;
  UpdateBookStateFromSocketEvent({required this.bookId, required this.isSaved});
}

// --- States ---
class BookActionsState {
  // bookId -> isSaved
  final Map<int, bool> savedBooks;

  BookActionsState({this.savedBooks = const {}});

  BookActionsState copyWith({Map<int, bool>? savedBooks}) {
    return BookActionsState(
      savedBooks: savedBooks ?? this.savedBooks,
    );
  }

  bool isBookSaved(int bookId, {bool defaultValue = false}) {
    return savedBooks[bookId] ?? defaultValue;
  }
}

// --- Bloc ---
class BookActionsBloc extends Bloc<BookActionsEvent, BookActionsState> {
  final SaveDeleteBookUseCase saveDeleteBookUseCase;
  final BookWebSocketService webSocketService;
  StreamSubscription? _socketSubscription;

  BookActionsBloc({
    required this.saveDeleteBookUseCase,
    required this.webSocketService,
  }) : super(BookActionsState()) {
    
    on<ToggleSaveBookEvent>((event, emit) async {
      // Optimistic Update
      final updatedMap = Map<int, bool>.from(state.savedBooks);
      updatedMap[event.bookId] = event.isSaved;
      emit(state.copyWith(savedBooks: updatedMap));

      try {
        await saveDeleteBookUseCase.call(event.bookId);
      } catch (e) {
        // Revert on failure
        final revertMap = Map<int, bool>.from(state.savedBooks);
        revertMap[event.bookId] = !event.isSaved;
        emit(state.copyWith(savedBooks: revertMap));
      }
    });

    on<UpdateBookStateFromSocketEvent>((event, emit) {
      final updatedMap = Map<int, bool>.from(state.savedBooks);
      updatedMap[event.bookId] = event.isSaved;
      emit(state.copyWith(savedBooks: updatedMap));
    });

    _initWebSocket();
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
              // Extract is_saved realistically, falling back to a hypothetical toggled state,
              // or using the passed `isActive` alternatively if needed depending on backend mapping
              final int bId = msg['id'];
              
              if (msg.containsKey('user_book_count')) {
                final bool bSaved = (msg['user_book_count'] ?? 0) >= 1;
                if (!isClosed) {
                  add(UpdateBookStateFromSocketEvent(bookId: bId, isSaved: bSaved));
                }
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
