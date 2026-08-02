import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';

class DataRequestsState extends Equatable {
  const DataRequestsState();

  @override
  List<Object?> get props => [];
}

class DataRequestsInitial extends DataRequestsState {}

class DataRequestsLoading extends DataRequestsState {}

class DataRequestsLoaded extends DataRequestsState {
  final DataRequestsResponse response;
  final String status;
  final String search;
  final bool isLoadingMore;
  final bool hasMore;

  const DataRequestsLoaded({
    required this.response,
    required this.status,
    required this.search,
    this.isLoadingMore = false,
    required this.hasMore,
  });

  bool get canLoadMore => hasMore && !isLoadingMore;

  DataRequestsLoaded copyWith({
    DataRequestsResponse? response,
    String? status,
    String? search,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return DataRequestsLoaded(
      response: response ?? this.response,
      status: status ?? this.status,
      search: search ?? this.search,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [response, status, search, isLoadingMore, hasMore];
}

class DataRequestsError extends DataRequestsState {}
