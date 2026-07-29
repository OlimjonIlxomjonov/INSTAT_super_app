import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_template/features/auth/presentation/auth_service/auth_service.dart';
import 'package:my_template/features/auth/presentation/auth_service/google_auth_service.dart';
import 'package:my_template/features/auth/presentation/data_source/one_id_log_in.dart';
import 'package:my_template/features/auth/presentation/widgets/continue_with_options.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

import '../../../../core/utils/constants/assets/app_images.dart';

class LogInOptionsComponent extends StatefulWidget {
  const LogInOptionsComponent({super.key});

  @override
  State<LogInOptionsComponent> createState() => _LogInOptionsComponentState();
}

class _LogInOptionsComponentState extends State<LogInOptionsComponent> {
  late final double screenHeight;

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
            Navigator.of(context).pop();

            if (error is DioException) {
              final statusCode = error.response?.statusCode;
              // final data = error.response?.data;

              errorFlushBar(
                context,
                AppLocalizations.of(
                  context,
                )!.loginFailedWithStatus(statusCode ?? 'unknown'),
              );

              logger.e(error.response?.data);
            } else {
              errorFlushBar(context, error.toString());
            }
          },
        ),
      ),
    );
  }

  Future<void> googleLogin() async {
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
      if (mounted) errorFlushBar(context, e.description ?? e.toString());
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
            AppLocalizations.of(
              context,
            )!.loginFailedWithStatus(statusCode ?? 'unknown'),
          );
        }
      } else {
        logger.e('Google sign-in failed', error: e, stackTrace: stackTrace);
        if (mounted) errorFlushBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Responsive(
      mobile: _buildMobile(localization),
      tablet: _buildSplit(localization, isDesktop: false),
      desktop: _buildSplit(localization, isDesktop: true),
    );
  }

  Widget _buildMobile(AppLocalizations localization) {
    return Stack(
      children: [
        /// CONTENT
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
            color: AppColors.primaryColor,
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
          style: AppTextStyles.source.bold(fontSize: 22),
        ),
        SizedBox(height: appH(8)),
        AutoSizeText(
          localization.registerOrEnterTheSystem,
          maxLines: 2,
          maxFontSize: 22,
          style: AppTextStyles.source.regular(
            fontSize: 15,
            color: AppColors.greyScale.grey600,
          ),
        ),
        SizedBox(height: appH(32)),

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
        SizedBox(height: appH(20)),

        ContinueWithOptions(
          iconPath: AppVectors.appleLogo,
          onTap: () {},
          continueWithText: localization.continueWithApple,
        ),
        ContinueWithOptions(
          iconPath: AppVectors.googleLogo,
          onTap: googleLogin,
          continueWithText: localization.continueWithGoogle,
        ),
        SafeArea(
          top: false,
          child: ContinueWithOptions(
            iconPath: AppVectors.facebookLogo,
            onTap: () {},
            continueWithText: localization.continueWithFaceBook,
          ),
        ),
      ],
    );
  }
}
