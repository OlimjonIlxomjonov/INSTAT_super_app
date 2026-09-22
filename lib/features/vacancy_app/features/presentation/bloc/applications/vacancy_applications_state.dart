import 'package:equatable/equatable.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_list_response.dart';

class VacancyApplicationsState extends Equatable {
  const VacancyApplicationsState();

  @override
  List<Object?> get props => [];
}

class VacancyApplicationsInitial extends VacancyApplicationsState {}

class VacancyApplicationsLoading extends VacancyApplicationsState {}

class VacancyApplicationsLoaded extends VacancyApplicationsState {
  final VacancyApplicationListResponse response;
  final bool isLoadingMore;
  final bool isRefreshing;

  const VacancyApplicationsLoaded({
    required this.response,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  bool get hasMore => response.meta.currentPage < response.meta.lastPage;

  VacancyApplicationsLoaded copyWith({
    VacancyApplicationListResponse? response,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return VacancyApplicationsLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [response, isLoadingMore, isRefreshing];
}

class VacancyApplicationsError extends VacancyApplicationsState {
  final String? message;

  const VacancyApplicationsError({this.message});

  @override
  List<Object?> get props => [message];
}
