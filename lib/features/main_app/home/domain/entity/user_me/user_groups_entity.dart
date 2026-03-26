class UserGroupsEntity {
  final int id;
  final String name;
  final List<int> permissions;

  const UserGroupsEntity({
    required this.id,
    required this.name,
    required this.permissions,
  });

}
