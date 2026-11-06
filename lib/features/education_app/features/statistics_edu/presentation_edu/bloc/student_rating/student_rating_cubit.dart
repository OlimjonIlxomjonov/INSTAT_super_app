import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/student_rating/student_rating_entity.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/usecase/student_rating/student_rating_use_case.dart';

class StudentRatingState {
  final StudentRatingEntity? data;
  final String? error;

  const StudentRatingState({this.data, this.error});

  bool get isLoading => data == null && error == null;
}

class StudentRatingCubit extends Cubit<StudentRatingState> {
  final StudentRatingUseCase useCase;

  StudentRatingCubit({required this.useCase})
    : super(const StudentRatingState());

  int _studentId = 0;

  Future<void> load(int studentId) async {
    _studentId = studentId;
    emit(const StudentRatingState());
    try {
      final data = await useCase(studentId);
      if (!isClosed) emit(StudentRatingState(data: data));
    } catch (e) {
      if (!isClosed) {
        emit(StudentRatingState(error: apiErrorMessage(e) ?? ''));
      }
    }
  }

  Future<void> retry() => load(_studentId);
}
