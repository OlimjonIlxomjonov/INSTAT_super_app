import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_test_direction_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';

class VacancyTestDirectionsState extends Equatable {
  const VacancyTestDirectionsState();

  @override
  List<Object?> get props => [];
}

class VacancyTestDirectionsLoading extends VacancyTestDirectionsState {}

class VacancyTestDirectionsLoaded extends VacancyTestDirectionsState {
  final List<VacancyTestDirectionEntity> items;

  const VacancyTestDirectionsLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class VacancyTestDirectionsError extends VacancyTestDirectionsState {
  final String? message;

  const VacancyTestDirectionsError({this.message});

  @override
  List<Object?> get props => [message];
}

class VacancyTestDirectionsCubit extends Cubit<VacancyTestDirectionsState> {
  final GetVacancyTestDirectionsUseCase useCase;

  VacancyTestDirectionsCubit({required this.useCase})
    : super(VacancyTestDirectionsLoading());

  Future<void> load(int vacancyId) async {
    emit(VacancyTestDirectionsLoading());
    try {
      final items = await useCase(vacancyId: vacancyId);
      if (isClosed) return;
      emit(VacancyTestDirectionsLoaded(items: items));
    } catch (e) {
      if (isClosed) return;
      emit(VacancyTestDirectionsError(message: apiErrorMessage(e)));
    }
  }
}
