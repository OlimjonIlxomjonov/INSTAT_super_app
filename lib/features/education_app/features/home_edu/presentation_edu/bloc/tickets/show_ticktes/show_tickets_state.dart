import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_response.dart';

class ShowTicketsState extends Equatable {
  const ShowTicketsState();

  @override
  List<Object?> get props => [];
}

class ShowTicketsInitial extends ShowTicketsState {}

class ShowTicketsLoading extends ShowTicketsState {}

class ShowTicketsLoaded extends ShowTicketsState {
  final ShowTicketsResponse response;

  const ShowTicketsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ShowTicketsError extends ShowTicketsState {}
