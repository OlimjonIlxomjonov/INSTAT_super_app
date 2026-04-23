import 'package:equatable/equatable.dart';

class AvatarState extends Equatable {
  const AvatarState();

  @override
  List<Object?> get props => [];
}

class AvatarInitial extends AvatarState {}

class AvatarLoading extends AvatarState {}

class AvatarLoaded extends AvatarState {}

class AvatarError extends AvatarState {}
