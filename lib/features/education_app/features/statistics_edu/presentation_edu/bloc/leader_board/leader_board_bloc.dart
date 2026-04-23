import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/usecase/leader_board/leader_board_use_case.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board/leader_board_state.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board_events.dart';

class LeaderBoardBloc extends Bloc<LeaderBoardMainEvents, LeaderBoardState> {
  final LeaderBoardUseCase useCase;

  LeaderBoardBloc(this.useCase) : super(LeaderBoardInitial()) {
    on<LeaderBoardEvent>((event, emit) async {
      emit(LeaderBoardLoading());
      try {
        final response = await useCase.call();
        emit(LeaderBoardLoaded(response));
      } catch (e) {
        emit(LeaderBoardError());
      }
    });
  }
}
