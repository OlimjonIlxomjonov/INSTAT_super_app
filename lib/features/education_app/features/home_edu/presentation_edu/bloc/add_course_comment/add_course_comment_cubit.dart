import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/add_course_comment/add_course_comment_use_case.dart';

class AddCourseCommentCubit extends Cubit<bool> {
  final AddCourseCommentUseCase useCase;

  AddCourseCommentCubit({required this.useCase}) : super(false);

  Future<void> submit(
    AddCourseCommentParams params, {
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
