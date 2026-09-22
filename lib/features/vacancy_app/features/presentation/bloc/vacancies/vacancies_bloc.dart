import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_list_response.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancies/vacancies_state.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/vacancy_event.dart';

class VacanciesBloc extends Bloc<VacancyEvent, VacanciesState> {
  final GetVacanciesUseCase useCase;

  VacancyListParams _params = const VacancyListParams();

  VacanciesBloc({required this.useCase}) : super(VacanciesInitial()) {
    on<FetchVacanciesEvent>((event, emit) async {
      _params = VacancyListParams(
        search: event.params.search,
        employmentType: event.params.employmentType,
      );

      /// KEEP OLD LIST
      final current = state;
      final previous =
          current is VacanciesLoaded && current.response.data.isNotEmpty
          ? current
          : null;

      emit(
        previous != null
            ? previous.copyWith(isRefreshing: true)
            : VacanciesLoading(),
      );

      try {
        final response = await useCase(params: _params);
        emit(VacanciesLoaded(response: response));
      } catch (e) {
        emit(
          previous?.copyWith(isRefreshing: false) ??
              VacanciesError(message: apiErrorMessage(e)),
        );
      }
    });

    on<LoadMoreVacanciesEvent>((event, emit) async {
      final current = state;
      if (current is! VacanciesLoaded) return;
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase(
          params: VacancyListParams(
            search: _params.search,
            employmentType: _params.employmentType,
            page: current.response.meta.currentPage + 1,
          ),
        );
        emit(
          VacanciesLoaded(
            response: VacancyListResponse(
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

  String? get employmentType => _params.employmentType;
}
