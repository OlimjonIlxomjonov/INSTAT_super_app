import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';
import 'package:my_template/features/mikro_data/domain/usecase/reports/reports_use_case.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_state.dart';

class ReportsBloc extends Bloc<MicroDataEvent, ReportsState> {
  final ReportsUseCase useCase;

  /// Load-more joriy qidiruv ichida davom etadi.
  String _search = '';

  ReportsBloc({required this.useCase}) : super(ReportsInitial()) {
    on<ReportsEvent>((event, emit) async {
      _search = event.search;

      /// KEEP OLD LIST
      final current = state;
      final previous =
          current is ReportsLoaded && current.response.data.isNotEmpty
          ? current
          : null;

      emit(
        previous != null
            ? previous.copyWith(isRefreshing: true)
            : ReportsLoading(),
      );

      try {
        final response = await useCase.call(search: _search);
        emit(ReportsLoaded(response: response));
      } catch (e) {
        emit(previous?.copyWith(isRefreshing: false) ?? ReportsError());
      }
    });

    on<LoadMoreReportsEvent>((event, emit) async {
      final current = state;
      if (current is! ReportsLoaded) return;
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      final nextPage = current.response.meta.currentPage + 1;

      try {
        final next = await useCase.call(search: _search, page: nextPage);
        emit(
          ReportsLoaded(
            response: ReportsResponse(
              links: next.links,
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
          ),
        );
      } catch (e) {
        emit(current.copyWith(isLoadingMore: false));
      }
    });
  }
}
