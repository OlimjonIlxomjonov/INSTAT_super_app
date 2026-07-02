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
