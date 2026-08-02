import 'package:my_template/core/error/exceptions.dart';

/// Backend xatolik konverti:
/// `{"ok": false, "error": {"type": "ValidationError", "details": {...}}}`
///
/// `details` ichidagi qiymat oddiy ro'yxat ham
/// (`{"category": ["This field may not be null."]}`), ichma-ich map ham
/// (`{"category": {"non_field_errors": [...]}}`) bo'lishi mumkin —
/// ikkalasi ham tekis ro'yxatga yig'iladi.
class ApiValidationParser {
  ApiValidationParser._();

  static ValidationException? tryParse(Object? responseBody) {
    if (responseBody is! Map) return null;

    final error = responseBody['error'];
    if (error is! Map) return null;

    final details = error['details'];
    if (details is! Map) return null;

    final fieldErrors = <String, List<String>>{};
    details.forEach((key, value) {
      final messages = _flatten(value);
      if (messages.isNotEmpty) fieldErrors[key.toString()] = messages;
    });

    if (fieldErrors.isEmpty) return null;
    return ValidationException(fieldErrors);
  }

  static List<String> _flatten(Object? value) {
    if (value is String) return [value];
    if (value is List) return value.expand(_flatten).toList();
    if (value is Map) return value.values.expand(_flatten).toList();
    return const [];
  }
}
