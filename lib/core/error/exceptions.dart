class ServerException implements Exception {
  final int? statusCode;
  final String? message;

  ServerException({this.statusCode, this.message});

  @override
  String toString() => 'ServerException: $statusCode - $message';
}

class CacheException implements Exception {}
