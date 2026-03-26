abstract class AuthConstants {
  static const String oneIdBaseUrl =
      'https://sso.egov.uz/sso/oauth/Authorization.do';
  static const String clientId = 'skills_xorijdaish';
  static const String redirectUri = 'https://test.avacoder.uz/api/one-id/login';
  static const String scope = 'skills_xorijdaish';

  static const String redirectPath = '/api/one-id/login';

  static String get authUrl => Uri.parse(oneIdBaseUrl)
      .replace(
        queryParameters: {
          'response_type': 'one_code',
          'client_id': clientId,
          'redirect_uri': redirectUri,
          'scope': scope,
          'state': 'testState',
        },
      )
      .toString();
}
