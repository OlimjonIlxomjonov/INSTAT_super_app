import 'package:equatable/equatable.dart';

class AddCommentsState extends Equatable {
  const AddCommentsState();

  @override
  List<Object?> get props => [];
}

class AddCommentsInitial extends AddCommentsState {}

class AddCommentsLoading extends AddCommentsState {}

class AddCommentsLoaded extends AddCommentsState {}

class AddCommentsError extends AddCommentsState {}
