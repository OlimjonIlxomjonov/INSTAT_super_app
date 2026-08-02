import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/data_requests_use_case.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_requests/data_requests_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class DataRequestsBloc extends Bloc<MicroDataEvent, DataRequestsState> {
  final DataRequestsUseCase useCase;

  DataRequestsBloc({required this.useCase}) : super(DataRequestsInitial()) {
    on<DataRequestsEvent>(_onDataRequests);
  }

  Future<void> _onDataRequests(
    DataRequestsEvent event,
    Emitter<DataRequestsState> emit,
  ) async {
    if (event.isLoadMore) {
      final currentState = state;
      if (currentState is! DataRequestsLoaded || !currentState.canLoadMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final response = await useCase.call(
          status: event.status,
          search: event.search,
          page: event.page,
        );

        // Sahifa kelguncha foydalanuvchi filtr yoki qidiruvni o'zgartirgan
        // bo'lishi mumkin. `currentState` await'dan oldin olingan, shuning
        // uchun uni copyWith qilish eski filtr natijalarini tiriltirib
        // yuborardi — bunday holatda sahifani tashlab yuboramiz.
        final latest = state;
        if (latest is! DataRequestsLoaded ||
            latest.status != currentState.status ||
            latest.search != currentState.search) {
          return;
        }

        emit(
          latest.copyWith(
            response: _mergeResponses(latest.response, response),
            isLoadingMore: false,
            hasMore: _hasMorePages(response),
          ),
        );
      } catch (_) {
        final latest = state;
        if (latest is DataRequestsLoaded &&
            latest.status == currentState.status &&
            latest.search == currentState.search) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
      return;
    }

    emit(DataRequestsLoading());
    try {
      final response = await useCase.call(
        status: event.status,
        search: event.search,
        page: event.page,
      );
      emit(
        DataRequestsLoaded(
          response: response,
          status: event.status,
          search: event.search,
          hasMore: _hasMorePages(response),
        ),
      );
    } catch (_) {
      emit(DataRequestsError());
    }
  }

  bool _hasMorePages(DataRequestsResponse response) {
    return response.links.next != null ||
        response.metaData.currentPage < response.metaData.lastPage;
  }

  DataRequestsResponse _mergeResponses(
    DataRequestsResponse current,
    DataRequestsResponse nextPage,
  ) {
    return DataRequestsResponse(
      links: nextPage.links,
      data: [...current.data, ...nextPage.data],
      metaData: nextPage.metaData,
    );
  }
}
