import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';

abstract class AuthConstants {
  static const String oneIdBaseUrl =
      'https://sso.egov.uz/sso/oauth/Authorization.do';
  static const String clientId = 'instat_uz';

  // static const String redirectUri = 'https://test.avacoder.uz/api/one-id/login';
  // static const String redirectUri = 'https://api1.instat.uz/api/one-id/login';

  static const String redirectUri = '${ApiUrls.baseUrl}one-id/login';

  static const String scope = 'instat_uz';

  static const String redirectPath = '/api/one-id/login';

  static const String googleServerClientId =
      '1050827484257-7k7mua9f0b2pai9fn6392auir1aeb6cq.apps.googleusercontent.com';

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
