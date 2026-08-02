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
  /// Accumulated across every page loaded so far.
  final LeaderBoardResponse response;

  /// True while an additional page is in flight; loaded rows stay visible.
  final bool isLoadingMore;

  const LeaderBoardLoaded(this.response, {this.isLoadingMore = false});

  /// A null `meta` means the endpoint returned no pagination block, which is
  /// treated as "nothing more to load".
  bool get hasMore {
    final meta = response.meta;
    if (meta == null) return false;
    return meta.currentPage < meta.lastPage;
  }

  LeaderBoardLoaded copyWith({
    LeaderBoardResponse? response,
    bool? isLoadingMore,
  }) {
    return LeaderBoardLoaded(
      response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [response, isLoadingMore];
}

class LeaderBoardError extends LeaderBoardState {}
