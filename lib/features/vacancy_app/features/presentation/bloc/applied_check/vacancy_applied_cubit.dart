import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';

enum VacancyAppliedStatus { loading, applied, notApplied, error }

class VacancyAppliedState extends Equatable {
  final VacancyAppliedStatus status;
  final VacancyApplicationEntity? application;

  const VacancyAppliedState({required this.status, this.application});

  @override
  List<Object?> get props => [status, application];
}

class VacancyAppliedCubit extends Cubit<VacancyAppliedState> {
  final GetVacancyApplicationsUseCase useCase;

  VacancyAppliedCubit({required this.useCase})
    : super(const VacancyAppliedState(status: VacancyAppliedStatus.loading));

  Future<void> check(int vacancyId) async {
    emit(const VacancyAppliedState(status: VacancyAppliedStatus.loading));
    try {
      final response = await useCase(
        params: VacancyApplicationListParams(vacancyId: vacancyId),
      );
      if (isClosed) return;
      if (response.data.isEmpty) {
        emit(
          const VacancyAppliedState(status: VacancyAppliedStatus.notApplied),
        );
      } else {
        emit(
          VacancyAppliedState(
            status: VacancyAppliedStatus.applied,
            application: response.data.first,
          ),
        );
      }
    } catch (_) {
      if (isClosed) return;
      emit(const VacancyAppliedState(status: VacancyAppliedStatus.error));
    }
  }
}
