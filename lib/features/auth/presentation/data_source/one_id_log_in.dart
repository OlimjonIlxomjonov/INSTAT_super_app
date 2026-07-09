import 'package:flutter/material.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/auth/presentation/auth_service/auth_service.dart';
import 'package:my_template/features/auth/presentation/data_source/auth_constatns.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _AuthState { loading, idle, error }

class OneIdLoginPage extends StatefulWidget {
  final OneIdAuthService authService;
  final VoidCallback onSuccess;
  final void Function(Exception error)? onFailure;

  const OneIdLoginPage({
    super.key,
    required this.authService,
    required this.onSuccess,
    this.onFailure,
  });

  @override
  State<OneIdLoginPage> createState() => _OneIdLoginPageState();
}

class _OneIdLoginPageState extends State<OneIdLoginPage> {
  late final WebViewController _controller;
  _AuthState _authState = _AuthState.loading;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _handleNavigation,
          onPageStarted: (_) => _setAuthState(_AuthState.loading),
          onPageFinished: (_) => _setAuthState(_AuthState.idle),
          onWebResourceError: (error) {
            // logger.e('WebView error: ${error.description}');
            // _setAuthState(_AuthState.error);
            if (error.description.contains('ERR_CONNECTION_TIMED_OUT')) {
              AppRoute.close();
              errorFlushBar(
                context,
                'Something went wrong please try again later!',
              );
            }
          },
        ),
      );
    // ..loadRequest(Uri.parse(AuthConstants.authUrl));
    _loadFreshAuthUrl();
  }

  Future<void> _loadFreshAuthUrl() async {
    // Wipe any existing OneID session cookies first
    await WebViewCookieManager().clearCookies();
    await _controller.loadRequest(Uri.parse(AuthConstants.authUrl));
  }

  Future<NavigationDecision> _handleNavigation(
    NavigationRequest request,
  ) async {
    final url = request.url;
    logger.i('Navigating to: $url');

    final uri = Uri.parse(url);

    if (uri.path.contains(AuthConstants.redirectPath)) {
      final code = uri.queryParameters['code'];

      if (code != null && code.isNotEmpty) {
        try {
          await widget.authService.handleAuthSuccess(code);
          widget.onSuccess();
        } on Exception catch (e) {
          logger.e('Auth handling failed: $e');
          widget.onFailure?.call(e);
        }
      } else {
        widget.onFailure?.call(
          Exception('Authorization code was not returned.'),
        );
      }

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _setAuthState(_AuthState state) {
    if (mounted) setState(() => _authState = state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OneID'), leading: const CloseButton()),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_authState == _AuthState.loading)
            const Center(child: CircularProgressIndicator()),
          if (_authState == _AuthState.error)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Something went wrong. Please try again.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _initController,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
