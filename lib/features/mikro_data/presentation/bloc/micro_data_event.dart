class MicroDataEvent {
  const MicroDataEvent();
}

//! reports
class ReportsEvent extends MicroDataEvent {}

//! user data requests
class DataRequestsEvent extends MicroDataEvent {
  /// Bo'sh string => barcha statuslar.
  final String status;
  final String search;
  final int page;
  final bool isLoadMore;

  const DataRequestsEvent({
    required this.status,
    required this.search,
    this.page = 1,
    this.isLoadMore = false,
  });
}
