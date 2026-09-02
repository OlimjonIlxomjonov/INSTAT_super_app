import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_template/features/auth/presentation/auth_service/auth_service.dart';
import 'package:my_template/features/auth/presentation/auth_service/google_auth_service.dart';
import 'package:my_template/features/auth/presentation/auth_service/qr_auth_service.dart';
import 'package:my_template/features/auth/presentation/data_source/one_id_log_in.dart';
import 'package:my_template/features/auth/presentation/screens/qr_login_scanner_page.dart';
import 'package:my_template/features/auth/presentation/screens/reviewer_screen/reviwer_log_in_page.dart';
import 'package:my_template/features/auth/presentation/widgets/continue_with_options.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';

class LogInOptionsComponent extends StatefulWidget {
  const LogInOptionsComponent({super.key});

  @override
  State<LogInOptionsComponent> createState() => _LogInOptionsComponentState();
}

class _LogInOptionsComponentState extends State<LogInOptionsComponent> {
  late final double screenHeight;
  bool _isGoogleLoading = false;
  bool _isQrLoading = false;

  @override
  void initState() {
    super.initState();
    screenHeight = AppResponsiveness.screenHeight;
  }

  void oneIdLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OneIdLoginPage(
          authService: OneIdAuthServiceImpl(
            tokenStorage: TokenStorageServiceImpl(),
            dioClient: DioClient(),
          ),
          onSuccess: () {
            final token = TokenStorageServiceImpl().getAccessToken();
            AppRoute.open(const HomePage());
            logger.i(token);
          },
          onFailure: (error) {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            final localization = AppLocalizations.of(context)!;
            if (error is DioException) {
              final statusCode = error.response?.statusCode;

              errorFlushBar(
                context,
                statusCode != null
                    ? localization.loginFailedWithStatus(statusCode)
                    : localization.somethingWentWrongTryAgain,
              );

              logger.e(error.response?.data);
            } else {
              errorFlushBar(context, localization.somethingWentWrongTryAgain);
            }
          },
        ),
      ),
    );
  }

  Future<void> googleLogin() async {
    if (_isGoogleLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await GoogleAuthServiceImpl(
        tokenStorage: TokenStorageServiceImpl(),
        dioClient: DioClient(),
      ).signIn();

      if (!mounted) return;

      AppRoute.open(const HomePage());
    } on GoogleSignInException catch (e, stackTrace) {
      if (e.code == GoogleSignInExceptionCode.canceled) return;

      logger.e(
        'Google sign-in failed: ${e.code}',
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        errorFlushBar(context, e.description ?? e.toString());
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        logger.e(
          'Google sign-in backend call failed',
          error: e.response?.data ?? e,
          stackTrace: stackTrace,
        );

        if (mounted) {
          final statusCode = e.response?.statusCode;

          errorFlushBar(
            context,
            statusCode != null
                ? AppLocalizations.of(
                    context,
                  )!.loginFailedWithStatus(statusCode)
                : AppLocalizations.of(context)!.somethingWentWrongTryAgain,
          );
        }
      } else {
        logger.e('Google sign-in failed', error: e, stackTrace: stackTrace);

        if (mounted) {
          errorFlushBar(context, e.toString());
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  // Future<void> appleLogin() async {
  //   try {
  //     await AppleAuthServiceImpl(
  //       tokenStorage: TokenStorageServiceImpl(),
  //       dioClient: DioClient(),
  //     ).signIn();
  //
  //     if (!mounted) return;
  //     AppRoute.open(const HomePage());
  //   } on SignInWithAppleAuthorizationException catch (e, stackTrace) {
  //     if (e.code == AuthorizationErrorCode.canceled) return;
  //
  //     logger.e(
  //       'Apple sign-in failed: ${e.code}',
  //       error: e,
  //       stackTrace: stackTrace,
  //     );
  //     if (mounted) errorFlushBar(context, e.message);
  //   } catch (e, stackTrace) {
  //     if (e is DioException) {
  //       logger.e(
  //         'Apple sign-in backend call failed',
  //         error: e.response?.data ?? e,
  //         stackTrace: stackTrace,
  //       );
  //       if (mounted) {
  //         final statusCode = e.response?.statusCode;
  //         errorFlushBar(
  //           context,
  //           AppLocalizations.of(
  //             context,
  //           )!.loginFailedWithStatus(statusCode ?? 'unknown'),
  //         );
  //       }
  //     } else {
  //       logger.e('Apple sign-in failed', error: e, stackTrace: stackTrace);
  //       if (mounted) errorFlushBar(context, e.toString());
  //     }
  //   }
  // }

  Future<void> _handleQrScan() async {
    if (_isQrLoading) return;

    final status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        errorFlushBar(context, 'Kameraga ruxsat berilmadi');
      }
      return;
    }
    if (!mounted) return;

    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrLoginScannerPage()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      await _performQrLogin(scannedCode);
    }
  }

  Future<void> _performQrLogin(String rawQrData) async {
    setState(() {
      _isQrLoading = true;
    });

    try {
      await QrAuthServiceImpl(
        tokenStorage: TokenStorageServiceImpl(),
        dioClient: DioClient(),
      ).loginWithQr(rawQrData);

      if (!mounted) return;
      AppRoute.open(const HomePage());
    } catch (e) {
      logger.e('QR login failed', error: e);
      if (mounted) {
        final msg = e.toString().replaceAll('Exception: ', '');
        errorFlushBar(context, msg);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isQrLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Responsive(
      mobile: _buildMobile(localization),
      tablet: orientation == Orientation.landscape
          ? _buildSplit(localization, isDesktop: false)
          : _buildMobile(localization),
      desktop: _buildSplit(localization, isDesktop: true),
    );
  }

  Widget _buildMobile(AppLocalizations localization) {
    return Stack(
      children: [
        //! TEMP QR BUTTON
        Positioned(
          right: 10,
          top: 0,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
                onPressed: _isQrLoading ? null : _handleQrScan,
                icon: _isQrLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        FlutterRemix.qr_scan_2_line,
                        size: 25,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),

        /// image / content
        Align(
          alignment: .bottomCenter,
          child: Column(
            mainAxisSize: .min,
            children: [
              Padding(
                padding: const .only(bottom: 150),
                child: SvgPicture.asset(AppVectors.mainAppLogo),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: .circular(25),
                    topRight: .circular(25),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: SingleChildScrollView(
                      child: _buildLoginOptionsContent(localization),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSplit(AppLocalizations localization, {required bool isDesktop}) {
    final split = Row(
      children: [
        Expanded(
          child: ColoredBox(
            color: AppColors.splashBackgroundColor,
            child: Center(
              child: SvgPicture.asset(
                AppVectors.mainAppLogo,
                width: isDesktop ? 220 : 180,
              ),
            ),
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: AppColors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48 : 32,
                  vertical: 32,
                ),
                child: _buildLoginOptionsContent(localization),
              ),
            ),
          ),
        ),
      ],
    );

    if (!isDesktop) return split;

    return Container(
      color: AppColors.greyScale.grey50,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 720),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: split,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOptionsContent(AppLocalizations localization) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          localization.getStart,
          maxFontSize: 35,
          style: AppTextStyles.source.semiBold(fontSize: 22),
        ),
        const SizedBox(height: 8),
        AutoSizeText(
          localization.registerOrEnterTheSystem,
          maxLines: 2,
          maxFontSize: 22,
          style: AppTextStyles.source.regular(
            fontSize: 14,
            color: AppColors.greyScale.grey600,
          ),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: oneIdLogin,
            child: SvgPicture.asset(AppVectors.oneIdLogo),
          ),
        ),

        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.greyScale.grey400)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appW(12)),
              child: AutoSizeText(
                localization.or,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.greyScale.grey400)),
          ],
        ),
        const SizedBox(height: 20),

        //! Apple sign-in
        if (Platform.isIOS)
          ContinueWithOptions(
            iconPath: AppVectors.appleLogo,
            onTap: () => errorFlushBar(context, 'Tez orada!'),
            continueWithText: localization.continueWithApple,
          ),
        //! google sign in
        ContinueWithOptions(
          iconPath: AppVectors.googleLogo,
          onTap: googleLogin,
          continueWithText: localization.continueWithGoogle,
          isLoading: _isGoogleLoading,
        ),
        SafeArea(
          top: false,
          child: ContinueWithOptions(
            iconPath: AppVectors.facebookLogo,
            onTap: () => errorFlushBar(context, 'Tez orada!'),
            continueWithText: localization.continueWithFaceBook,
          ),
        ),
      ],
    );
  }
}
