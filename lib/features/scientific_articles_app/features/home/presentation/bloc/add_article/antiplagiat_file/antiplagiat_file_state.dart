import 'package:equatable/equatable.dart';

class AntiplagiatFileState extends Equatable {
  const AntiplagiatFileState();

  @override
  List<Object?> get props => [];
}

class AntiplagiatFileInitial extends AntiplagiatFileState {}

class AntiplagiatFileLoading extends AntiplagiatFileState {}

class AntiplagiatFileLoaded extends AntiplagiatFileState {}

class AntiplagiatFileError extends AntiplagiatFileState {}
