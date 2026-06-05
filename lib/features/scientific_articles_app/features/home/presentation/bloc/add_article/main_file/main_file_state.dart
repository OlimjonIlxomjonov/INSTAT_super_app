import 'package:equatable/equatable.dart';

class MainFileState extends Equatable {
  const MainFileState();

  @override
  List<Object?> get props => [];
}

class MainFileInitial extends MainFileState {}

class MainFileLoading extends MainFileState {}

class MainFileLoaded extends MainFileState {}

class MainFileError extends MainFileState {}
