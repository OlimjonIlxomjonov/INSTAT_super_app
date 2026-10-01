import 'dart:io';

import 'package:dio/dio.dart';

/// Whether [error] genuinely indicates the *device* has no usable internet
/// connection — as opposed to the request having reached (or attempted to
/// reach) the server and failed there for some other reason (bad TLS
/// certificate, server down, malformed response, etc).
///
/// [DioExceptionType.unknown] is Dio's catch-all for anything it couldn't
/// categorize — this includes TLS/certificate handshake failures
/// (`HandshakeException`), which happen only once a connection to the
/// server *was* established, so treating every `unknown` error as "no
/// internet" is wrong and misleads the user when the actual problem is on
/// the server's end. Only a real [SocketException] (DNS failure, connection
/// refused, etc.) justifies that message.
bool isNoInternetError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return true;
    case DioExceptionType.unknown:
      return error.error is SocketException;
    default:
      return false;
  }
}

/// Backend xatosidan foydalanuvchiga ko'rsatsa bo'ladigan matn.
///
/// Qo'llab-quvvatlanadigan shakllar:
///   {"error": {"details": {"detail": "..."}}}
///   {"error": "..."}
///   {"error": {"details": ["...", ...]}}
///   {"error": {"details": {"field": ["..."]}}}
///   {"detail": "..."}  /  {"message": "..."}
///
/// Hech biri topilmasa `null` — chaqiruvchi umumiy matnni ko'rsatadi.
String? apiErrorMessage(Object error) {
  if (error is! DioException) return null;
  if (isNoInternetError(error)) return null;

  final data = error.response?.data;
  if (data is! Map) return null;

  //! Uzun yoki ko'p qatorli dump UI'ga sig'maydi
  String? clean(String value) {
    final firstLine = value.trim().split('\n').first.trim();
    if (firstLine.isEmpty) return null;
    return firstLine.length > 160
        ? '${firstLine.substring(0, 160)}…'
        : firstLine;
  }

  String? pick(dynamic value) {
    if (value is String) return clean(value);
    if (value is List && value.isNotEmpty) return pick(value.first);
    if (value is Map && value.isNotEmpty) {
      return pick(value['detail']) ?? pick(value.values.first);
    }
    return null;
  }

  final err = data['error'];
  if (err is String) {
    final fromString = pick(err);
    if (fromString != null) return fromString;
  }
  if (err is Map) {
    //! Server xatosida details texnik dump bo'ladi — turi ko'rsatiladi
    final type = err['type']?.toString();
    if (type != null && type.isNotEmpty && type.endsWith('ServerError')) {
      final message = pick(data['message']);
      return message == null || message == type ? type : '$type · $message';
    }

    final fromDetails = pick(err['details']);
    if (fromDetails != null) return fromDetails;
    final fromMessage = pick(err['message']);
    if (fromMessage != null) return fromMessage;
  }

  return pick(data['detail']) ?? pick(data['message']);
}

/// Texnik tafsilot — `error.details`. UI'da asosiy xabar ostida
/// bitta qator bo'lib chiqadi.
String? apiErrorDetails(Object error) {
  if (error is! DioException) return null;
  if (isNoInternetError(error)) return null;

  final data = error.response?.data;
  if (data is! Map) return null;

  final err = data['error'];
  if (err is! Map) return null;

  final details = err['details'];
  final text = details is List
      ? (details.isEmpty ? null : details.first?.toString())
      : details?.toString();

  if (text == null) return null;
  final firstLine = text.trim().split('\n').first.trim();
  return firstLine.isEmpty ? null : firstLine;
}
