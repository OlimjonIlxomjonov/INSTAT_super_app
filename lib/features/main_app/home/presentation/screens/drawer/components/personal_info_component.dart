import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_form_field_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalInfoComponent extends StatefulWidget {
  const PersonalInfoComponent({super.key});

  @override
  State<PersonalInfoComponent> createState() => _PersonalInfoComponentState();
}

class _PersonalInfoComponentState extends State<PersonalInfoComponent> {
  @override
  void initState() {
    super.initState();
    if (context.read<UserMeBloc>().state is! UserMeLoaded) _fetch();
  }

  void _fetch() => context.read<UserMeBloc>().add(UserMeEvent());

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomRefreshIndicator(
      onRefresh: () async => _fetch(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: CustomAppBarWg(myTitle: localization.personalInfo),
              ),
            ),
            SliverPadding(
              padding: const .fromLTRB(20, 10, 20, 30),
              sliver: BlocBuilder<UserMeBloc, UserMeState>(
                builder: (context, state) {
                  if (state is UserMeError) {
                    return SliverToBoxAdapter(
                      child: SectionErrorWg(
                        title: state.message,
                        onRetry: _fetch,
                      ),
                    );
                  }

                  final isLoading = state is! UserMeLoaded;
                  final user = state is UserMeLoaded
                      ? state.entity
                      : _placeholderUser;

                  return SliverToBoxAdapter(
                    child: Skeletonizer(
                      enabled: isLoading,
                      child: _PersonalInfoForm(user: user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _placeholderUser = UserEntity(
  id: 0,
  username: 'username',
  email: 'user@mail.uz',
  firstName: 'Ism',
  lastName: 'Familiya',
  groups: [],
  isSuperuser: false,
  isVerified: false,
  isResident: true,
  phoneNumber: '+998 90 123 45 67',
  birthDate: '2000-01-01',
);

class _PersonalInfoForm extends StatelessWidget {
  final UserEntity user;

  const _PersonalInfoForm({required this.user});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: .start,
      children: [
        //! Roles
        if (user.groups.isNotEmpty) ...[
          _RolesSection(user: user),
          const SizedBox(height: 20),
        ],
        //! Fields
        _InfoFieldWg(label: localization.firstNameLabel, value: user.firstName),
        _InfoFieldWg(label: localization.lastNameLabel, value: user.lastName),
        _InfoFieldWg(
          label: localization.phoneNumberLabel,
          value: user.phoneNumber,
        ),
        _InfoFieldWg(
          label: localization.emailLabel,
          value: user.email,
          icon: FlutterRemix.mail_line,
        ),
        _InfoFieldWg(
          label: localization.birthDateLabel,
          value: _formatDate(user.birthDate),
        ),
      ],
    );
  }

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return raw.toReadableDateWithoutTime();
    } catch (_) {
      return raw;
    }
  }
}

class _RolesSection extends StatelessWidget {
  final UserEntity user;

  const _RolesSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          localization.userRoles,
          style: AppTextStyles.source.medium(fontSize: 14),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.groups
              .map((group) => _RoleChip(name: group.name))
              .toList(),
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String name;

  const _RoleChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.eduCategorySelectedBg,
        borderRadius: .circular(20),
        border: .all(color: AppColors.primaryColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(
            FlutterRemix.shield_user_line,
            size: 14,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: AppTextStyles.source.medium(
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoFieldWg extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? icon;

  const _InfoFieldWg({required this.label, this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;

    return AppFormFieldWg(
      label: label,
      child: Container(
        width: double.infinity,
        padding: const .symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          border: .all(color: AppColors.greyScale.grey300),
          borderRadius: .circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.greyScale.grey500),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                hasValue ? value! : AppLocalizations.of(context)!.notProvided,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: hasValue
                      ? AppColors.greyScale.grey900
                      : AppColors.greyScale.grey400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
