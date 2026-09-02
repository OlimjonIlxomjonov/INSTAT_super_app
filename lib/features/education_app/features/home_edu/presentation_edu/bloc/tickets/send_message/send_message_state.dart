class SendMessageState {
  const SendMessageState();
}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {}

class SendMessageLoaded extends SendMessageState {}

class SendMessageError extends SendMessageState {}
