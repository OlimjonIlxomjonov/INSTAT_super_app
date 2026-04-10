import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/check_final_test_access/check_final_test_access_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class CheckFinalTestAccessBloc
    extends Bloc<CoursesEvent, CheckFinalTestAccessState> {
  final CheckFinalTestAccessUseCase useCase;

  CheckFinalTestAccessBloc({required this.useCase})
    : super(CheckFinalTestAccessInitial()) {
    on<CheckFinalTestAccessEvent>((event, emit) async {
      emit(CheckFinalTestAccessLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(CheckFinalTestAccessLoaded(entity));
      } catch (e) {
        emit(CheckFinalTestAccessError());
      }
    });
  }
}
