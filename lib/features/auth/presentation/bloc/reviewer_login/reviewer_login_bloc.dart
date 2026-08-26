import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/error/exceptions.dart';
import 'package:my_template/features/auth/domain/usecase/reviewer_login_use_case.dart';
import 'package:my_template/features/auth/presentation/bloc/reviewer_login/reviewer_login_event.dart';
import 'package:my_template/features/auth/presentation/bloc/reviewer_login/reviewer_login_state.dart';

class ReviewerLoginBloc extends Bloc<ReviewerLoginEvent, ReviewerLoginState> {
  final ReviewerLoginUseCase useCase;

  ReviewerLoginBloc({required this.useCase}) : super(ReviewerLoginInitial()) {
    on<SubmitReviewerLoginEvent>((event, emit) async {
      emit(ReviewerLoginLoading());
      try {
        await useCase.call(
          username: event.username,
          password: event.password,
        );
        emit(ReviewerLoginSuccess());
      } on ServerException catch (e) {
        emit(
          ReviewerLoginError(
            message: e.message ?? 'Authentication failed',
            statusCode: e.statusCode,
          ),
        );
      } catch (e) {
        emit(ReviewerLoginError(message: e.toString()));
      }
    });
  }
}
