/// Base type for leaderboard events.
class LeaderBoardMainEvents {
  const LeaderBoardMainEvents();
}

/// Loads (or reloads) the first page, replacing whatever was there.
class LeaderBoardEvent extends LeaderBoardMainEvents {}

/// Appends the next page. A *sibling* of [LeaderBoardEvent] rather than a
/// subclass — bloc's `on<E>` also matches subtypes, so extending it would
/// make every load-more additionally reload page 1.
class LoadMoreLeaderBoardEvent extends LeaderBoardMainEvents {
  const LoadMoreLeaderBoardEvent();
}
