import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_response.dart';

class CertificateState extends Equatable {
  const CertificateState();

  @override
  List<Object?> get props => [];
}

class CertificateInitial extends CertificateState {}

class CertificateLoading extends CertificateState {}

class CertificateLoaded extends CertificateState {
  final UserCertificateResponse response;

  const CertificateLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class CertificateError extends CertificateState {}
