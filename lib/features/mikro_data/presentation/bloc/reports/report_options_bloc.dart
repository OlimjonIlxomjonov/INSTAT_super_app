import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/usecase/reports/get_report_options_use_case.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/report_options_state.dart';

class ReportOptionsBloc extends Bloc<MicroDataEvent, ReportOptionsState> {
  final GetReportOptionsUseCase useCase;

  ReportOptionsBloc({required this.useCase}) : super(ReportOptionsInitial()) {
    on<FetchReportOptionsEvent>((event, emit) async {
      emit(ReportOptionsLoading());
      try {
        final options = await useCase.call(event.reportId);
        emit(ReportOptionsLoaded(options: options));
      } catch (e) {
        emit(ReportOptionsError(message: e.toString()));
      }
    });
  }
}
