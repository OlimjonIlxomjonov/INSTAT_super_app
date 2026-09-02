class CreateTicketsState {
  const CreateTicketsState();
}

class CreateTicketsInitial extends CreateTicketsState {}

class CreateTicketsLoading extends CreateTicketsState {}

class CreateTicketsLoaded extends CreateTicketsState {}

class CreateTicketsError extends CreateTicketsState {}
