import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_error_messages.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_single_file_upload_section_wg.dart';

/// Backend PDF, ZIP, DOCX ni 1 GB gacha qabul qiladi.
const Set<String> _allowedExtensions = {'pdf', 'zip', 'docx'};
const int _maxFileSizeBytes = 1024 * 1024 * 1024;

class RequestFileSectionWg extends StatelessWidget {
  const RequestFileSectionWg({super.key});

  Future<void> _pickAndUpload(BuildContext context) async {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();

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

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
      buildWhen: (prev, curr) =>
          prev.isUploadingFile != curr.isUploadingFile ||
          prev.fileName != curr.fileName ||
          prev.fileSize != curr.fileSize,
      builder: (context, state) {
        return ArticleSingleFileUploadSectionWg(
          title: localization.requestAttachFileTitle,
          formatsHint: localization.requestAttachFileFormats,
          isUploading: state.isUploadingFile,
          onPickTap: () => _pickAndUpload(context),
          existingFileName: state.fileName.isEmpty ? null : state.fileName,
          existingFileSize: formatRequestFileSize(state.fileSize),
        );
      },
    );
  }
}
