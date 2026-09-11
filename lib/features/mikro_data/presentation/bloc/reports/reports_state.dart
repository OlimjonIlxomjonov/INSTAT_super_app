import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';

class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final ReportsResponse response;
  final bool isLoadingMore;
  final bool isRefreshing;

  const ReportsLoaded({
    required this.response,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  bool get hasMore => response.meta.currentPage < response.meta.lastPage;

  ReportsLoaded copyWith({
    ReportsResponse? response,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return ReportsLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [response, isLoadingMore, isRefreshing];
}

class ReportsError extends ReportsState {}
