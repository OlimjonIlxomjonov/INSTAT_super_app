import 'dart:convert';

/// JWT'ning `exp` maydoni. Token buzuq bo'lsa `null`.
DateTime? jwtExpiry(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final map = jsonDecode(payload);
    final exp = map is Map ? map['exp'] : null;
    if (exp is! num) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
  } catch (_) {
    return null;
  }
}

/// `exp` o'qib bo'lmasa token yaroqsiz deb hisoblanadi.
bool isJwtExpired(
  String token, {
  Duration leeway = const Duration(seconds: 30),
}) {
  final expiry = jwtExpiry(token);
  if (expiry == null) return true;
  return DateTime.now().toUtc().add(leeway).isAfter(expiry);
}
