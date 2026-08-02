import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/user_articles/user_articles_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_state.dart';

class UserArticlesBloc extends Bloc<ArticlesHomeEvent, UserArticlesState> {
  final UserArticlesUseCase useCase;

  UserArticlesBloc({required this.useCase}) : super(UserArticlesInitial()) {
    on<UserArticlesEvent>(_onUserArticles);
  }

  Future<void> _onUserArticles(
    UserArticlesEvent event,
    Emitter<UserArticlesState> emit,
  ) async {
    if (event.isLoadMore) {
      final currentState = state;
      if (currentState is! UserArticlesLoaded || !currentState.canLoadMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final response = await useCase.call(
          status: event.status,
          search: event.search,
          page: event.page,
        );

        // The user may have switched filter/search while this page was in
        // flight. `currentState` was captured before the await, so emitting
        // a copyWith of it here would resurrect the old filter's results
        // and merge the stale page into them — discard instead.
        final latest = state;
        if (latest is! UserArticlesLoaded ||
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
        if (latest is UserArticlesLoaded &&
            latest.status == currentState.status &&
            latest.search == currentState.search) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
      return;
    }

    emit(UserArticlesLoading());
    try {
      final response = await useCase.call(
        status: event.status,
        search: event.search,
        page: event.page,
      );
      emit(
        UserArticlesLoaded(
          response: response,
          status: event.status,
          search: event.search,
          hasMore: _hasMorePages(response),
        ),
      );
    } catch (_) {
      emit(UserArticlesError());
    }
  }

  bool _hasMorePages(UserArticlesResponse response) {
    return response.links.next != null ||
        response.metaData.currentPage < response.metaData.lastPage;
  }

  UserArticlesResponse _mergeResponses(
    UserArticlesResponse current,
    UserArticlesResponse nextPage,
  ) {
    return UserArticlesResponse(
      links: nextPage.links,
      data: [...current.data, ...nextPage.data],
      metaData: nextPage.metaData,
    );
  }
}
