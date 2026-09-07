import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/confirm_dialog/confirm_dialog_wg.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_error_messages.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_file_opener.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_section_card_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';

const Set<String> _allowedExtensions = {
  'pdf',
  'zip',
  'docx',
  'jpg',
  'jpeg',
  'png',
};
const int _maxFileSizeBytes = 50 * 1024 * 1024;

class RequestFileSectionWg extends StatelessWidget {
  const RequestFileSectionWg({
    super.key,
    required this.title,
    required this.subtitle,
    this.isCompanyFile = false,
  });

  final String title;
  final String subtitle;
  final bool isCompanyFile;

  Future<void> _pickAndUpload(BuildContext context) async {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();

    // Fayl endpointi id talab qiladi — ariza saqlanmagan bo'lsa id yo'q.
    final requestId = bloc.state.requestId;
    if (requestId == null || requestId == 0) {
      errorFlushBar(context, localization.requestSaveToUploadFile);
      return;
    }

    try {
      final picked = await ArticleFilePickerHelper.pickFiles(
        allowedExtensions: _allowedExtensions,
        allowMultiple: false,
        invalidExtensionMessage: localization.requestAttachFileFormats,
        noFileChosenMessage: localization.requestUploadError,
        pickErrorMessage: localization.requestUploadError,
      );
      if (picked.isEmpty || !context.mounted) return;

      final entry = picked.first;
      final size = await entry.file.length();
      if (size > _maxFileSizeBytes) {
        if (context.mounted) {
          errorFlushBar(context, localization.requestFileTooLarge);
        }
        return;
      }

      bloc.add(
        UploadDataRequestFileEvent(
          file: entry.file,
          fileName: entry.name,
          fileSize: size,
          isCompanyFile: isCompanyFile,
          onError: (error) {
            if (context.mounted) {
              errorFlushBar(context, describeRequestError(error, localization));
            }
          },
        ),
      );
    } on ArticleFilePickerException catch (e) {
      if (context.mounted) errorFlushBar(context, e.message);
    }
  }

  void _confirmDelete(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();

    showConfirmDialog(
      context,
      title: localization.requestDeleteFileTitle,
      description: localization.requestDeleteFileDescription,
      confirmText: localization.deleteAction,
      cancelText: localization.cancel,
      onConfirm: () {
        bloc.add(
          DeleteDataRequestFileEvent(
            isCompanyFile: isCompanyFile,
            onSuccess: () {
              if (context.mounted) {
                successFlushBar(context, localization.requestFileDeleted);
              }
            },
            onError: (error) {
              if (context.mounted) {
                errorFlushBar(
                  context,
                  describeRequestError(error, localization),
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
      builder: (context, state) {
        final isUploading = isCompanyFile
            ? state.isUploadingCompanyFile
            : state.isUploadingFile;
        final hasFile = isCompanyFile ? state.hasCompanyFile : state.hasFile;
        final fileName = isCompanyFile ? state.companyFileName : state.fileName;
        final fileSize = isCompanyFile ? state.companyFileSize : state.fileSize;
        final fileUrl = isCompanyFile ? state.companyFileUrl : state.fileUrl;

        return RequestSectionCardWg(
          title: title,
          subtitle: subtitle,
          bordered: true,
          children: [
            if (isUploading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            else if (hasFile) ...[
              SelectedFileContainerWg(
                fileName: fileName,
                fileSize: formatRequestFileSize(fileSize),
                onTap: () =>
                    openRequestFile(context, url: fileUrl, fileName: fileName),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _pickAndUpload(context),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(localization.requestSelectAction),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.redFailedTaskCard,
                    ),
                    label: Text(
                      localization.requestDeleteFileTitle,
                      style: AppTextStyles.source.medium(
                        fontSize: 13,
                        color: AppColors.redFailedTaskCard,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              DottedContainerWg(
                formatsHint: localization.requestAttachFileFormats,
                onTap: () => _pickAndUpload(context),
              ),
          ],
        );
      },
    );
  }
}
