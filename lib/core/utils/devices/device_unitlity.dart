import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TDeviceUtils {
  static Future<void> systemNavigationBar(
    Color color, {
    bool isBright = false,
  }) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: isBright
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  static Future<void> setStatusBarColor(
    Color color, {
    bool darkIcons = true,
  }) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,

        // Android: icon color
        statusBarIconBrightness: darkIcons ? Brightness.dark : Brightness.light,

        // iOS: status bar text color (inverted)
        statusBarBrightness: darkIcons ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

abstract class AppPadding {
  static EdgeInsets horizontal20x() => .symmetric(horizontal: 20);

  static EdgeInsets hAndV20x20() => .symmetric(horizontal: 20, vertical: 20);
}

String formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;

  if (hours > 0 && minutes > 0) {
    return '$hours soat $minutes daqiqa';
  } else if (hours > 0) {
    return '$hours soat';
  } else {
    return '$minutes daqiqa';
  }
}

String formatPrice(Object price) {
  final number = price is num ? price : (num.tryParse(price.toString()) ?? 0);
  final digits = number.round().abs().toString();

  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }

  return number < 0 ? '-$buffer' : buffer.toString();
}

String formatFileSize(int bytes) {
  double kb = bytes / 1024;
  double mb = kb / 1024;

  if (mb >= 1) {
    return '${mb.toStringAsFixed(2)} MB';
  } else {
    return '${kb.toStringAsFixed(2)} KB';
  }
}

extension DateTimeFormatting on String {
  String toReadableDate() {
    DateTime dateTime = DateTime.parse(this);
    return "${dateTime.day} ${_getMonth(dateTime.month)} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute}";
  }

  String toReadableDateWithoutTime() {
    DateTime dateTime = DateTime.parse(this);
    return "${dateTime.day} ${_getMonth(dateTime.month)} ${dateTime.year}";
  }
}

String _getMonth(int month) {
  const months = [
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'Iyun',
    'Iyul',
    'Avgust',
    'Sentabr',
    'Oktabr',
    'Noyabr',
    'Dekabr',
  ];
  return months[month - 1];
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension NotificationDateExtension on String {
  String toNotificationDateTime() {
    final DateTime dateTime = DateTime.parse(this);
    final String time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    final DateTime now = DateTime.now();
    final DateTime dateOnly = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateOnly == today) {
      return 'Bugun $time';
    } else if (dateOnly == yesterday) {
      return 'Kecha $time';
    } else {
      return '${toReadableDateWithoutTime()} $time';
    }
  }
}

extension LastSeenExtension on String {
  String toLastSeenText() {
    final DateTime dateTime = DateTime.parse(this);
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'Hozirgina';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} daqiqa oldin';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} soat oldin';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} kun oldin';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks hafta oldin';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months oy oldin';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years yil oldin';
    }
  }
}

extension DateTimeStringX on String {
  String toReadableTime() {
    final dt = DateTime.parse(this);
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
