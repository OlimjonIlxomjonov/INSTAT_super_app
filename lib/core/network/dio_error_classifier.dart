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
