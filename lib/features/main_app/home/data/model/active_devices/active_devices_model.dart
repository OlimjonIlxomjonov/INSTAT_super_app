import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';

class ActiveDevicesModel extends ActiveDevicesEntity {
  ActiveDevicesModel({
    required super.id,
    required super.device,
    required super.ip,
    required super.location,
    required super.browser,
    required super.created,
    required super.lastSeen,
  });

  factory ActiveDevicesModel.fromJson(Map<String, dynamic> json) {
    return ActiveDevicesModel(
      id: json['id'] ?? 0,
      device: json['device'] ?? 'Unknown Device',
      ip: json['ip'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      browser: json['browser'] ?? 'Unknown Browser',
      created: json['created'] ?? 'Unknown Date',
      lastSeen: json['last_seen'] ?? 'Unknown Date',
    );
  }
}
