import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';

class SearchStudentsState {
  const SearchStudentsState();
}

class SearchStudentsInitial extends SearchStudentsState {}

class SearchStudentsLoading extends SearchStudentsState {}

class SearchStudentsLoaded extends SearchStudentsState {
  final LeaderBoardResponse response;

  SearchStudentsLoaded({required this.response});
}

class SearchStudentsError extends SearchStudentsState {
  final bool isConnectionError;
  final String message;

  SearchStudentsError({
    required this.isConnectionError,
    required this.message,
  });
}
