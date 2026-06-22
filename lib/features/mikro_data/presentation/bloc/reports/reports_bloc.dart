import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/usecase/reports/reports_use_case.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_state.dart';

class ReportsBloc extends Bloc<MicroDataEvent, ReportsState> {
  final ReportsUseCase useCase;

  ReportsBloc({required this.useCase}) : super(ReportsInitial()) {
    on<ReportsEvent>((event, emit) async {
      emit(ReportsLoading());
      try {
        final response = await useCase.call();
        emit(ReportsLoaded(response: response));
      } catch (e) {
        emit(ReportsError());
      }
    });
  }
}
