import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_process_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';

class VacancyProcessesState extends Equatable {
  const VacancyProcessesState();

  @override
  List<Object?> get props => [];
}

class VacancyProcessesLoading extends VacancyProcessesState {}

class VacancyProcessesLoaded extends VacancyProcessesState {
  final List<VacancyProcessEntity> items;

  const VacancyProcessesLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class VacancyProcessesError extends VacancyProcessesState {
  final String? message;

  const VacancyProcessesError({this.message});

  @override
  List<Object?> get props => [message];
}

class VacancyProcessesCubit extends Cubit<VacancyProcessesState> {
  final GetVacancyProcessesUseCase useCase;

  VacancyProcessesCubit({required this.useCase})
    : super(VacancyProcessesLoading());

  Future<void> load(int applicationId) async {
    emit(VacancyProcessesLoading());
    try {
      final items = await useCase(applicationId: applicationId);
      if (isClosed) return;
      items.sort((a, b) {
        final ad = a.createdAt ?? DateTime(0);
        final bd = b.createdAt ?? DateTime(0);
        return ad.compareTo(bd);
      });
      emit(VacancyProcessesLoaded(items: items));
    } catch (e) {
      if (isClosed) return;
      emit(VacancyProcessesError(message: apiErrorMessage(e)));
    }
  }
}
