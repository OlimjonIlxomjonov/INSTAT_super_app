class ServerException implements Exception {
  final int? statusCode;
  final String? message;

  ServerException({this.statusCode, this.message});

  @override
  String toString() => 'ServerException: $statusCode - $message';
}

class CacheException implements Exception {}

/// Backend field-level validation errors, e.g.
/// `{"error": {"type": "ValidationError", "details": {"pport_no": ["..."]}}}`.
/// Kept separate from [ServerException] so callers can show the exact
/// per-field message instead of a generic error.
class ValidationException implements Exception {
  final Map<String, List<String>> fieldErrors;

  ValidationException(this.fieldErrors);

  String? firstErrorFor(String field) {
    final messages = fieldErrors[field];
    return (messages != null && messages.isNotEmpty) ? messages.first : null;
  }

  @override
  String toString() => 'ValidationException: $fieldErrors';
}
