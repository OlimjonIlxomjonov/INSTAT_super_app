import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_category/course_category_by_id_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class UserCategoryByIdBloc
    extends Bloc<UserCategoryByIdEvent, UserCategoryByIdState> {
  final CourseCategoryByIdUseCase useCase;

  UserCategoryByIdBloc(this.useCase) : super(UserCategoryByIdInitial()) {
    on<UserCategoryByIdEvent>((event, emit) async {
      emit(UserCategoryByIdLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(UserCategoryByIdLoaded(entity: entity));
      } catch (e) {
        emit(UserCategoryByIdError());
      }
    });
  }
}
