import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

/// Shown after the splash screen when there is no internet connection.
/// Automatically navigates to destination once internet is detected.
/// Also provides a manual retry button that re-checks immediately.
class NoInternetPage extends StatefulWidget {
  /// The page to open once connectivity is confirmed (HomePage or OnboardingPage).
  final Widget destination;

  const NoInternetPage({super.key, required this.destination});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  StreamSubscription<InternetStatus>? _statusSub;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _listenForConnection();
  }

  void _listenForConnection() {
    _statusSub = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected && mounted) {
        _navigateToDestination();
      }
    });
  }

  Future<void> _retry() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final hasInternet = await InternetConnection().hasInternetAccess;

    if (!mounted) return;
    setState(() => _isChecking = false);

    if (hasInternet) {
      _navigateToDestination();
    }
  }

  void _navigateToDestination() {
    AppRoute.open(widget.destination);
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Lottie.asset(
                    AppAnimations.lostInternetConnectionState,
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Internet aloqasi yo\'q',
                  style: CustomTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Iltimos, internet aloqangizni tekshiring va qayta urinib ko\'ring.',
                  style: CustomTextStyles.h4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _isChecking
                    ? CircularProgressIndicator(color: AppColors.primaryColor)
                    : FilledButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Qayta urinish'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
