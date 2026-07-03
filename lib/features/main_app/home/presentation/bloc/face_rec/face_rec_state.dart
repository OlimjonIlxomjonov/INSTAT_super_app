import 'package:equatable/equatable.dart';

class FaceRecState extends Equatable {
  const FaceRecState();

  @override
  List<Object?> get props => [];
}

class FaceRecInitial extends FaceRecState {}

class FaceRecLoading extends FaceRecState {}

class FaceRecLoaded extends FaceRecState {}

class FaceRecError extends FaceRecState {}

class FaceRecSessionLoading extends FaceRecState {}

class FaceRecSessionLoaded extends FaceRecState {
  final String sessionId;

  const FaceRecSessionLoaded({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class FaceRecSessionError extends FaceRecState {
  final String message;

  const FaceRecSessionError({required this.message});

  @override
  List<Object?> get props => [message];
}
