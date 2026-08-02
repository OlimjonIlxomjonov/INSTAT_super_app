import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/usecase/leader_board/leader_board_use_case.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board/leader_board_state.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board_events.dart';

class LeaderBoardBloc extends Bloc<LeaderBoardMainEvents, LeaderBoardState> {
  final LeaderBoardUseCase useCase;

  LeaderBoardBloc(this.useCase) : super(LeaderBoardInitial()) {
    on<LeaderBoardEvent>((event, emit) async {
      emit(LeaderBoardLoading());
      try {
        // Always page 1 so a reload replaces rather than appends.
        final response = await useCase.call(page: 1);
        emit(LeaderBoardLoaded(response));
      } catch (e) {
        emit(LeaderBoardError());
      }
    });

    on<LoadMoreLeaderBoardEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page exists.
      if (current is! LeaderBoardLoaded) return;

      // Drop the event while a page is in flight or at the last page. Safe
      // against duplicates because `emit` updates `state` synchronously and
      // nothing awaits between this check and the emit below.
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase.call(
          page: current.response.meta!.currentPage + 1,
        );

        emit(
          LeaderBoardLoaded(
            LeaderBoardResponse(
              links: next.links,
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep the rows already on screen — emitting LeaderBoardError here
        // would blank the whole leaderboard over one failed page.
        final latest = state;
        if (latest is LeaderBoardLoaded) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
