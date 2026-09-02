class TicketsChatUserEntity {
  final int id;
  final String userName, email, avatar, firstName, lastName;
  final bool isVerified;

  TicketsChatUserEntity({
    required this.id,
    required this.userName,
    required this.email,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
  });
}
