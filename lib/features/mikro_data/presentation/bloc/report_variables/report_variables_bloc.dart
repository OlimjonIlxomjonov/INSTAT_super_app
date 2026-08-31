import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/usecase/report_variables/report_variables_use_case.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/report_variables/report_variables_state.dart';

class ReportVariablesBloc
    extends Bloc<MicroDataEvent, ReportVariablesState> {
  final ReportVariablesUseCase useCase;

  ReportVariablesBloc({required this.useCase})
    : super(ReportVariablesInitial()) {
    on<ReportVariablesEvent>((event, emit) async {
      emit(ReportVariablesLoading());
      try {
        final listEntity = await useCase.call(params: event.params);
        emit(ReportVariablesLoaded(listEntity: listEntity));
      } catch (e) {
        emit(ReportVariablesError());
      }
    });
  }
}
