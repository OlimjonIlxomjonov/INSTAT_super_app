import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';

class LeaderBoardState extends Equatable {
  const LeaderBoardState();

  @override
  List<Object?> get props => [];
}

class LeaderBoardInitial extends LeaderBoardState {}

class LeaderBoardLoading extends LeaderBoardState {}

class LeaderBoardLoaded extends LeaderBoardState {
  final LeaderBoardResponse response;

  const LeaderBoardLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class LeaderBoardError extends LeaderBoardState {}
