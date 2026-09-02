import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/send_message/send_message_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/tickets_chat/tickets_chat_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/tickets_chat/tickets_chat_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../home_edu/presentation_edu/bloc/tickets/send_message/send_message_state.dart';

class EduTicketsChatComponent extends StatefulWidget {
  final int ticketId;

  const EduTicketsChatComponent({super.key, required this.ticketId});

  @override
  State<EduTicketsChatComponent> createState() =>
      _EduTicketsChatComponentState();
}

class _EduTicketsChatComponentState extends State<EduTicketsChatComponent> {
  final TextEditingController _messageController = TextEditingController();
  File? _selectedFile;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _removeSelectedFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  void _handleSend() {
    final message = _messageController.text.trim();
    if (message.isEmpty && _selectedFile == null) return;

    context.read<SendMessageBloc>().add(
      SendMessageEvent(
        params: SendMessageParams(
          ticketId: widget.ticketId,
          message: message,
          file: _selectedFile,
        ),
      ),
    );

    _messageController.clear();
    setState(() {
      _selectedFile = null;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<TicketsChatBloc>().add(
      TicketsChatEvent(params: TicketsChatParams(ticketId: widget.ticketId)),
    );
  }

  bool _isSameDay(String a, String b) {
    final dateA = DateTime.parse(a);
    final dateB = DateTime.parse(b);
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  Future<void> _openFile(String filePath) async {
    const baseUrl = ApiUrls.videoBase;
    final fullUrl = filePath.startsWith('http')
        ? filePath
        : '$baseUrl$filePath';
    final uri = Uri.parse(fullUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
    logger.f(fullUrl);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocListener<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state is SendMessageLoaded) {
          context.read<TicketsChatBloc>().add(
            TicketsChatEvent(
              params: TicketsChatParams(ticketId: widget.ticketId),
            ),
          );
        } else if (state is SendMessageError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Xabar yuborilmadi')));
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: SheetDragAreaWg(
                  child: CustomAppBarWg(myTitle: localization.chatTitle),
                ),
                titleSpacing: 0,
                automaticallyImplyLeading: false,
              ),
              BlocBuilder<TicketsChatBloc, TicketsChatState>(
                builder: (context, state) {
                  if (state is TicketsChatLoaded) {
                    final data = state.listEntity;
                    if (data.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppEmptyState(
                          title: 'Hali xabarlar yo‘q',
                          subtitle:
                              'Birinchi xabarni yuboring va ushbu sahifani jonlantiring.',
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final showDateHeader =
                            index == 0 ||
                            !_isSameDay(
                              data[index - 1].createdAt,
                              item.createdAt,
                            );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //!Date
                            if (showDateHeader)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.greyScale.grey100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.createdAt
                                          .toReadableDateWithoutTime(),
                                    ),
                                  ),
                                ),
                              ),
                            //! Message
                            if (item.message.isNotEmpty)
                              Align(
                                alignment: item.isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                        0.95,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.isUser
                                          ? AppColors.userChatBackground
                                          : AppColors.greyScale.grey50,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(14),
                                        topRight: const Radius.circular(14),
                                        bottomLeft: Radius.circular(
                                          item.isUser ? 14 : 2,
                                        ),
                                        bottomRight: Radius.circular(
                                          item.isUser ? 2 : 14,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: item.isUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.message,
                                          style: AppTextStyles.source.regular(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          textAlign: item.isUser
                                              ? .start
                                              : .end,
                                          item.createdAt.toReadableTime(),
                                          style: AppTextStyles.source.regular(
                                            fontSize: 12,
                                            color: AppColors.greyScale.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            //! File
                            if (item.fileName.isNotEmpty)
                              Align(
                                alignment: item.isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 2,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _openFile(item.file!),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 260,
                                      ),
                                      child: SelectedFileContainerWg(
                                        fileName: item.fileName,
                                        fileSize: formatFileSize(
                                          item.fileSize ?? 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  }
                  //! Skeletonizer / loading
                  return SliverList.builder(
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final isUser = index.isEven;
                      return Skeletonizer(
                        enabled: true,
                        child: Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greyScale.grey50,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(14),
                                  topRight: const Radius.circular(14),
                                  bottomLeft: Radius.circular(isUser ? 14 : 2),
                                  bottomRight: Radius.circular(isUser ? 2 : 14),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    index.isEven
                                        ? 'Bu yerda xabar matni bo\'ladi'
                                        : 'Qisqaroq xabar',
                                    style: AppTextStyles.source.regular(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '00:00',
                                    style: AppTextStyles.source.regular(
                                      fontSize: 12,
                                      color: AppColors.greyScale.grey600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //! Selected file preview
                if (_selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greyScale.grey50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.greyScale.grey300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FlutterRemix.file_line,
                            size: 18,
                            color: AppColors.greyScale.grey600,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedFile!.path.split('/').last,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.source.regular(fontSize: 13),
                            ),
                          ),
                          GestureDetector(
                            onTap: _removeSelectedFile,
                            child: Icon(
                              FlutterRemix.close_line,
                              size: 18,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                //! Input row
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyScale.grey300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: _pickFile,
                        icon: Icon(
                          FlutterRemix.attachment_2,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Сообщение',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      BlocBuilder<SendMessageBloc, SendMessageState>(
                        builder: (context, state) {
                          final isSending = state is SendMessageLoading;
                          return IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isSending ? null : _handleSend,
                            icon: isSending
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : Icon(IconlyBold.send, color: AppColors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
