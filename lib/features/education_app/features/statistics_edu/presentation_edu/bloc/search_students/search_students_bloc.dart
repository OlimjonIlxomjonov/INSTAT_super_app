import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/usecase/search_students/search_students_use_case.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_event.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_state.dart';

class SearchStudentsBloc
    extends Bloc<SearchStudentsBaseEvent, SearchStudentsState> {
  final SearchStudentsUseCase useCase;

  SearchStudentsBloc({required this.useCase}) : super(SearchStudentsInitial()) {
    on<SearchStudentsEvent>((event, emit) async {
      emit(SearchStudentsLoading());
      try {
        // Always page 1 — a new query replaces results rather than appending.
        final response = await useCase.call(
          params: SearchStudentsParams(search: event.params.search, page: 1),
        );
        emit(
          SearchStudentsLoaded(
            response: response,
            query: event.params.search,
          ),
        );
      } on DioException catch (e) {
        emit(
          SearchStudentsError(
            isConnectionError: isNoInternetError(e),
            message: e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(
          SearchStudentsError(
            isConnectionError: isSocketError,
            message: e.toString(),
          ),
        );
      }
    });

    on<LoadMoreSearchStudentsEvent>((event, emit) async {
      final current = state;

      if (current is! SearchStudentsLoaded) return;
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase.call(
          params: SearchStudentsParams(
            // Extend the *same* query these results belong to.
            search: current.query,
            page: current.response.meta!.currentPage + 1,
          ),
        );

        // Discard a page that arrived after the query changed.
        final latest = state;
        if (latest is! SearchStudentsLoaded || latest.query != current.query) {
          return;
        }

        emit(
          SearchStudentsLoaded(
            response: LeaderBoardResponse(
              links: next.links,
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            query: current.query,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep results on screen; clearing the flag allows a retry.
        final latest = state;
        if (latest is SearchStudentsLoaded && latest.query == current.query) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
