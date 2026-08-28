import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/features/mikro_data/domain/usecase/report_files/report_files_use_case.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/report_files/report_files_stat.dart';

class ReportFilesBloc extends Bloc<MicroDataEvent, ReportFilesState> {
  final ReportFilesUseCase useCase;

  ReportFilesBloc({required this.useCase}) : super(ReportFilesInitial()) {
    on<ReportFilesEvent>((event, emit) async {
      emit(ReportFilesLoading());
      try {
        final listEntity = await useCase.call(params: event.params);
        emit(ReportFilesLoaded(listEntity: listEntity));
      } catch (e) {
        emit(ReportFilesError());
      }
    });
  }
}
