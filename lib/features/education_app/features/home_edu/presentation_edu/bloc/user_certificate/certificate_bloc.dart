import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/user_certificates/user_certificate_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/user_certificate/certificate_state.dart';

class CertificateBloc extends Bloc<HomeEduEvent, CertificateState> {
  final UserCertificateUseCase useCase;

  CertificateBloc({required this.useCase}) : super(CertificateInitial()) {
    on<UserCertificateEvent>((event, emit) async {
      emit(CertificateLoading());
      try {
        final response = await useCase.call();
        emit(CertificateLoaded(response: response));
      } catch (e) {
        emit(CertificateError());
      }
    });
  }
}
