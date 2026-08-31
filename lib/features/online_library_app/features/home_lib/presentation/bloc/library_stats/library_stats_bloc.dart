import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/library_stats/library_stats_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/library_stats/library_stats_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/library_stats/library_stats_state.dart';

class LibraryStatsBloc extends Bloc<LibraryStatsEvent, LibraryStatsState> {
  final LibraryStatsUseCase useCase;

  LibraryStatsBloc({required this.useCase}) : super(LibraryStatsInitial()) {
    on<LibraryStatsEvent>((event, emit) async {
      emit(LibraryStatsLoading());
      try {
        final entity = await useCase.call();
        emit(LibraryStatsLoaded(entity: entity));
      } catch (e) {
        emit(LibraryStatsError());
      }
    });
  }
}
