import 'package:equatable/equatable.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_list_response.dart';

class VacanciesState extends Equatable {
  const VacanciesState();

  @override
  List<Object?> get props => [];
}

class VacanciesInitial extends VacanciesState {}

class VacanciesLoading extends VacanciesState {}

class VacanciesLoaded extends VacanciesState {
  final VacancyListResponse response;
  final bool isLoadingMore;
  final bool isRefreshing;

  const VacanciesLoaded({
    required this.response,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  bool get hasMore => response.meta.currentPage < response.meta.lastPage;

  VacanciesLoaded copyWith({
    VacancyListResponse? response,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return VacanciesLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [response, isLoadingMore, isRefreshing];
}

class VacanciesError extends VacanciesState {
  final String? message;

  const VacanciesError({this.message});

  @override
  List<Object?> get props => [message];
}
