import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/vacancy_app/features/domain/usecase/vacancy_use_cases.dart';

class VacancyApplyCubit extends Cubit<bool> {
  final ApplyVacancyUseCase useCase;

  VacancyApplyCubit({required this.useCase}) : super(false);

  Future<void> submit(
    ApplyVacancyParams params, {
    required void Function() onSuccess,
    required void Function(String? message) onError,
  }) async {
    if (state) return;
    emit(true);
    try {
      await useCase(params: params);
      if (isClosed) return;
      emit(false);
      onSuccess();
    } catch (e) {
      if (isClosed) return;
      emit(false);
      onError(apiErrorMessage(e));
    }
  }
}
