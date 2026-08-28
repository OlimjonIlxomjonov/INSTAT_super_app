class ActiveDevicesEntity {
  final int id;
  final String device, ip, location, browser, created, lastSeen;

  ActiveDevicesEntity({
    required this.id,
    required this.device,
    required this.ip,
    required this.location,
    required this.browser,
    required this.created,
    required this.lastSeen,
  });
}
