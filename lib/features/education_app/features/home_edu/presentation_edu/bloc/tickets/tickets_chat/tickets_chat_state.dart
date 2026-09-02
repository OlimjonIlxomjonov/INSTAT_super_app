import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_entity.dart';

class TicketsChatState extends Equatable {
  const TicketsChatState();

  @override
  List<Object?> get props => [];
}

class TicketsChatInitial extends TicketsChatState {}

class TicketsChatLoading extends TicketsChatState {}

class TicketsChatLoaded extends TicketsChatState {
  final List<TicketsChatEntity> listEntity;

  const TicketsChatLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class TicketsChatError extends TicketsChatState {}
