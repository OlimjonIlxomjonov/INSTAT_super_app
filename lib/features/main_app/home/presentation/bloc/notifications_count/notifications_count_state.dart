import 'package:equatable/equatable.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications_count/notifications_count_entity.dart';

class NotifCountState extends Equatable {
  const NotifCountState();

  @override
  List<Object?> get props => [];
}

class NotifCountInitial extends NotifCountState {}

class NotifCountLoading extends NotifCountState {}

class NotifCountLoaded extends NotifCountState {
  final NotificationsCountEntity entity;

  NotifCountLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class NotifCountError extends NotifCountState {}
