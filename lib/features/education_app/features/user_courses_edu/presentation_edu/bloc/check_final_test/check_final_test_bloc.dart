// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/check_final_test_access/check_final_test_access_use_case.dart';
// import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test/check_final_test_state.dart';
// import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
//
// class CheckFinalTestBloc extends Bloc<CoursesEvent, CheckFinalTestState> {
//   final CheckFinalTestAccessUseCase useCase;
//
//   CheckFinalTestBloc({required this.useCase}) : super(CheckFinalTestInitial()) {
//     on<CheckFinalTestAccessEvent>((event, emit) async {
//       emit(CheckFinalTestLoading());
//       try {
//         final entity = await useCase.call(params: event.params);
//         emit(CheckFinalTestLoaded(entity: entity));
//       } catch (e) {
//         emit(CheckFinalTestError());
//       }
//     });
//   }
// }
