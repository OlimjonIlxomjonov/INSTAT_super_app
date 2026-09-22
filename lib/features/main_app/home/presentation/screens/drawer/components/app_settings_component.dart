import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/services/banners/banner_source_cubit.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/dot_switch/dot_switch_wg.dart';
import 'package:my_template/core/utils/widgets/app_version/app_version_service.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:permission_handler/permission_handler.dart';

class AppSettingsComponent extends StatefulWidget {
  const AppSettingsComponent({super.key});

  @override
  State<AppSettingsComponent> createState() => _AppSettingsComponentState();
}

class _AppSettingsComponentState extends State<AppSettingsComponent>
    with WidgetsBindingObserver {
  PermissionStatus? _cameraStatus;
  String? _version;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _readCameraStatus();
    _readVersion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _readCameraStatus();
  }

  Future<void> _readCameraStatus() async {
    final status = await Permission.camera.status;
    if (mounted) setState(() => _cameraStatus = status);
  }

  Future<void> _readVersion() async {
    final version = await AppVersionService.fullVersion();
    if (mounted) setState(() => _version = version);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 5)),
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: localization.appSettingsLabel),
            ),
          ),
          SliverPadding(
            padding: const .fromLTRB(20, 10, 20, 30),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  //! Permissions
                  _SectionTitle(title: localization.permissionsSection),
                  _PermissionCard(
                    icon: FlutterRemix.camera_line,
                    title: localization.cameraPermissionLabel,
                    subtitle: localization.cameraPermissionUsage,
                    status: _cameraStatus,
                    onOpenSettings: openAppSettings,
                  ),
                  const SizedBox(height: 24),
                  //! Bannerlar
                  _SectionTitle(title: localization.bannersSection),
                  BlocBuilder<BannerSourceCubit, bool>(
                    builder: (context, useRemote) => _SwitchCard(
                      icon: FlutterRemix.image_line,
                      title: localization.promoBannersLabel,
                      subtitle: localization.promoBannersHint,
                      value: useRemote,
                      onChanged: (value) =>
                          context.read<BannerSourceCubit>().setUseRemote(value),
                    ),
                  ),
                  const SizedBox(height: 24),
                  //! About
                  _SectionTitle(title: localization.aboutAppSection),
                  _InfoCard(
                    icon: FlutterRemix.information_line,
                    title: localization.appVersionLabel,
                    value: _version ?? '—',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.source.medium(fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
          DotSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 10),
      child: Text(title, style: AppTextStyles.source.medium(fontSize: 14)),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final PermissionStatus? status;
  final VoidCallback onOpenSettings;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isGranted = status?.isGranted ?? false;

    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        border: .all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.source.medium(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // _StatusBadge(label: label, color: color),
              CircleAvatar(
                radius: 22,
                backgroundColor: isGranted
                    ? AppColors.iconGreenBackground
                    : AppColors.greyScale.grey200,
                child: Icon(
                  icon,
                  size: 20,
                  color: isGranted
                      ? AppColors.iconGreen
                      : AppColors.greyScale.grey600,
                ),
              ),
            ],
          ),
          //! Sozlamalar faqat ruxsat yo'q bo'lganda kerak
          if (status != null && !isGranted) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenSettings,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.greyScale.grey300),
                  shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                ),
                icon: const Icon(FlutterRemix.settings_3_line, size: 16),
                label: Text(
                  localization.permissionOpenSettings,
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: .circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.source.medium(fontSize: 12, color: color),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        border: .all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.greyScale.grey600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.source.medium(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
