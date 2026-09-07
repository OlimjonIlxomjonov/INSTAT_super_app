import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/confirm_dialog/confirm_dialog_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/general_widgets/simple_btn_container_wg/simple_btn_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_report_ref_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/page_view_screens/request_documents_view.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/page_view_screens/request_environment_view.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/page_view_screens/request_personal_info_view.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/page_view_screens/request_summary_view.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_error_messages.dart';

class AddDataRequestPage extends StatelessWidget {
  final int? editRequestId;
  final DataReportRefEntity? initialReport;

  const AddDataRequestPage({super.key, this.editRequestId, this.initialReport});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddDataRequestBloc>(),
      child: _AddDataRequestView(
        editRequestId: editRequestId,
        initialReport: initialReport,
      ),
    );
  }
}

class _AddDataRequestView extends StatefulWidget {
  const _AddDataRequestView({this.editRequestId, this.initialReport});

  final int? editRequestId;
  final DataReportRefEntity? initialReport;

  @override
  State<_AddDataRequestView> createState() => _AddDataRequestViewState();
}

class _AddDataRequestViewState extends State<_AddDataRequestView> {
  static const int _stepCount = 4;

  final _pageController = PageController();

  int _currentPage = 0;
  double _progress = 1 / _stepCount;

  bool get _isLastPage => _currentPage == _stepCount - 1;

  bool get _isEditMode => widget.editRequestId != null;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page;
      if (page == null) return;
      setState(() => _progress = (page + 1) / _stepCount);
    });

    final editId = widget.editRequestId;
    if (editId != null) {
      context.read<AddDataRequestBloc>().add(
        LoadDataRequestForEditEvent(requestId: editId),
      );
      return;
    }

    final report = widget.initialReport;
    if (report != null) {
      context.read<AddDataRequestBloc>().add(
        UpdateDataRequestFieldEvent(dataReport: report),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> _stepTitles(AppLocalizations localization) => [
    localization.requestStepBasicInfo,
    localization.requestStepLegalBasis,
    localization.requestStepSecurityEnv,
    localization.requestStepConfirmation,
  ];

  void _moveNextOrSubmit() {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();

    // Bosqichlar orasida erkin yurish mumkin, tekshiruv yuborishda.
    if (!_isLastPage) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (!bloc.state.canSubmit) {
      errorFlushBar(context, localization.requestFillRequiredFields);
      return;
    }

    bloc.add(
      SubmitDataRequestEvent(
        onSuccess: () {
          if (!mounted) return;
          showSuccessDialog(
            context,
            title: localization.requestSentTitle,
            description: localization.requestSentDescription,
            onDismiss: () => FamilyNavigation.familyClose(context),
          );
        },
        onError: (error) {
          if (mounted) {
            errorFlushBar(context, describeRequestError(error, localization));
          }
        },
      ),
    );
  }

  void _saveDraft() {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();

    // Backend POST'da 1-bosqich maydonlarini majburiy qiladi.
    if (!bloc.state.canSaveDraft) {
      errorFlushBar(context, localization.requestDraftNeedsStepOne);
      return;
    }

    bloc.add(
      SaveDataRequestDraftEvent(
        onSuccess: () {
          if (mounted) {
            successFlushBar(context, localization.draftSavedSuccessfully);
          }
        },
        onError: (error) {
          if (mounted) {
            errorFlushBar(context, describeRequestError(error, localization));
          }
        },
      ),
    );
  }

  void _showExitDialog() {
    final localization = AppLocalizations.of(context)!;
    showConfirmDialog(
      context,
      title: localization.exitConfirmTitle,
      description: _isEditMode
          ? localization.exitConfirmEditMode
          : localization.exitConfirmNewMode,
      onConfirm: () => FamilyNavigation.familyClose(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final stepTitles = _stepTitles(localization);
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _showExitDialog();
        },
        child: BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
          builder: (context, state) {
            if (_isEditMode && state.isLoadingInitialData) {
              return _EditModeScaffold(
                title: localization.requestEditTitle,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            if (_isEditMode && state.initialLoadError != null) {
              return _EditModeScaffold(
                title: localization.requestEditTitle,
                child: Center(
                  child: Padding(
                    padding: AppPadding.horizontal20x(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localization.somethingWentWrongTitle,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.h3half,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              FamilyNavigation.familyClose(context),
                          child: Text(localization.back),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: Text(
                      _isEditMode
                          ? localization.requestEditTitle
                          : localization.submitRequest,
                      style: CustomTextStyles.h2,
                    ),
                  ),
                  bottomNavigationBar: keyboardVisible
                      ? null
                      : SimpleBtnContainerWg(
                          onFirstTap: _showExitDialog,
                          onSecondTap: state.isSaving
                              ? null
                              : _moveNextOrSubmit,
                          onSecondText: _isLastPage
                              ? localization.requestSubmitButton
                              : localization.nextStep,
                        ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// STEP LABEL + COUNTER
                      Padding(
                        padding: AppPadding.horizontal20x(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                localization.requestStepLabel(
                                  _currentPage + 1,
                                  stepTitles[_currentPage],
                                ),
                                style: CustomTextStyles.h4,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${_currentPage + 1} / $_stepCount',
                              style: CustomTextStyles.h4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// PROGRESS
                      Padding(
                        padding: AppPadding.horizontal20x(),
                        child: CustomLinearIndicatorWg(
                          progressIndicator: _progress * 100,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// SECTION TITLE + SAVE DRAFT
                      Padding(
                        padding: AppPadding.horizontal20x(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                stepTitles[_currentPage],
                                style: CustomTextStyles.h2,
                              ),
                            ),
                            GestureDetector(
                              onTap: state.isSaving ? null : _saveDraft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greyScale.grey50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      IconlyLight.document,
                                      color: AppColors.greyScale.grey600,
                                    ),
                                    Text(
                                      ' ${localization.save}',
                                      style: AppTextStyles.source.medium(
                                        fontSize: 12,
                                        color: AppColors.greyScale.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          children: const [
                            RequestPersonalInfoView(),
                            RequestDocumentsView(),
                            RequestEnvironmentView(),
                            RequestSummaryView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.isSaving)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 28,
                            horizontal: 36,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator.adaptive(),
                              const SizedBox(height: 16),
                              Text(localization.savingEllipsis),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Tahrirlash rejimidagi yuklanish/xato ekranlari uchun umumiy qobiq.
class _EditModeScaffold extends StatelessWidget {
  const _EditModeScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(title, style: CustomTextStyles.h2),
      ),
      body: child,
    );
  }
}
