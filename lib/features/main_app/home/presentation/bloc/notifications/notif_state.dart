import 'package:equatable/equatable.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_response.dart';

class NotifState extends Equatable {
  const NotifState();

  @override
  List<Object?> get props => [];
}

class NotifInitial extends NotifState {}

class NotifLoading extends NotifState {}

class NotifLoaded extends NotifState {
  final NotifResponse response;

  const NotifLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class NotifError extends NotifState {}
