import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_event.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/applications/vacancy_applications_state.dart';

class VacancyApplicationsBloc
    extends Bloc<VacancyApplicationsEvent, VacancyApplicationsState> {
  final GetVacancyApplicationsUseCase useCase;

  VacancyApplicationListParams _params = const VacancyApplicationListParams();

  VacancyApplicationsBloc({required this.useCase})
    : super(VacancyApplicationsInitial()) {
    on<FetchVacancyApplicationsEvent>((event, emit) async {
      _params = VacancyApplicationListParams(
        search: event.params.search,
        status: event.params.status,
      );

      /// KEEP OLD LIST
      final current = state;
      final previous =
          current is VacancyApplicationsLoaded &&
              current.response.data.isNotEmpty
          ? current
          : null;

      emit(
        previous != null
            ? previous.copyWith(isRefreshing: true)
            : VacancyApplicationsLoading(),
      );

      try {
        final response = await useCase(params: _params);
        emit(VacancyApplicationsLoaded(response: response));
      } catch (e) {
        emit(
          previous?.copyWith(isRefreshing: false) ??
              VacancyApplicationsError(message: apiErrorMessage(e)),
        );
      }
    });

    on<LoadMoreVacancyApplicationsEvent>((event, emit) async {
      final current = state;
      if (current is! VacancyApplicationsLoaded) return;
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase(
          params: VacancyApplicationListParams(
            search: _params.search,
            status: _params.status,
            page: current.response.meta.currentPage + 1,
          ),
        );
        emit(
          VacancyApplicationsLoaded(
            response: VacancyApplicationListResponse(
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
