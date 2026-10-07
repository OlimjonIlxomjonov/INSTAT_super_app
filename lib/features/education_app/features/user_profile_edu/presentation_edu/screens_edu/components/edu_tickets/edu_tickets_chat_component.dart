import 'dart:io';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart'
    show IndicatorTrigger;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/services/token_storage/jwt_utils.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/files/remote_file_opener.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/widgets/image_viewer/image_viewer_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/send_message/send_message_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/tickets_chat/tickets_chat_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/tickets_chat/tickets_chat_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../home_edu/presentation_edu/bloc/tickets/send_message/send_message_state.dart';

const _imageExtensions = {
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'heic',
  'heif',
  'bmp',
};

bool _isImageName(String name) {
  final dot = name.lastIndexOf('.');
  if (dot < 0) return false;
  return _imageExtensions.contains(name.substring(dot + 1).toLowerCase());
}

String _fullUrl(String path) =>
    path.startsWith('http') ? path : '${ApiUrls.videoBase}$path';

class EduTicketsChatComponent extends StatefulWidget {
  final int ticketId;

  const EduTicketsChatComponent({super.key, required this.ticketId});

  @override
  State<EduTicketsChatComponent> createState() =>
      _EduTicketsChatComponentState();
}

class _EduTicketsChatComponentState extends State<EduTicketsChatComponent> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  File? _selectedFile;
  bool _selectedIsImage = false;
  bool _scrollAfterReload = false;
  final Set<int> _openingFiles = {};

  //! Rolidan qat'i nazar o'z xabarim o'ngda
  late final int? _myUserId = () {
    final token = TokenStorageServiceImpl().getAccessToken();
    return token == null ? null : jwtUserId(token);
  }();

  bool _isMine(TicketsChatEntity item) =>
      _myUserId != null ? item.user.id == _myUserId : item.isUser;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _reload() {
    context.read<TicketsChatBloc>().add(
      TicketsChatEvent(params: TicketsChatParams(ticketId: widget.ticketId)),
    );
  }

  //! Teskari ro'yxatda 0 — eng pastki xabar
  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _openAttachSheet() {
    final localization = AppLocalizations.of(context)!;
    FocusManager.instance.primaryFocus?.unfocus();
    onlineLibStyleCustomBottomSheetWg(
      context,
      headerTitle: localization.attachTitle,
      child: Builder(
        builder: (sheetContext) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AttachOption(
              icon: IconlyLight.image,
              label: localization.attachGallery,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickFromGallery();
              },
            ),
            _AttachOption(
              icon: IconlyLight.document,
              label: localization.attachFile,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2048,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedFile = File(picked.path);
      _selectedIsImage = true;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    final path = result?.files.single.path;
    if (path == null || !mounted) return;
    setState(() {
      _selectedFile = File(path);
      _selectedIsImage = _isImageName(path);
    });
  }

  void _removeSelectedFile() => setState(() => _selectedFile = null);

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
    setState(() => _selectedFile = null);
    _scrollToBottom();
  }

  Future<void> _openFile(TicketsChatEntity item) async {
    if (_openingFiles.contains(item.id)) return;
    setState(() => _openingFiles.add(item.id));
    try {
      await openRemoteFile(
        context,
        url: _fullUrl(item.file!),
        fileName: item.fileName,
      );
    } finally {
      if (mounted) setState(() => _openingFiles.remove(item.id));
    }
  }

  void _openImage(TicketsChatEntity item, ImageProvider thumbnail) {
    final url = _fullUrl(item.file!);
    showImageViewer(
      context,
      image: NetworkImage(url),
      placeholder: thumbnail,
      heroTag: _heroTag(item),
      onOpenExternal: () =>
          openRemoteFile(context, url: url, fileName: item.fileName),
    );
  }

  Object _heroTag(TicketsChatEntity item) => 'ticket-message-${item.id}';

  bool _isSameDay(String a, String b) {
    final dateA = DateTime.parse(a);
    final dateB = DateTime.parse(b);
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<SendMessageBloc, SendMessageState>(
          listener: (context, state) {
            if (state is SendMessageLoaded) {
              _scrollAfterReload = true;
              _reload();
            } else if (state is SendMessageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.messageNotSent)),
              );
            }
          },
        ),
        BlocListener<TicketsChatBloc, TicketsChatState>(
          listener: (context, state) {
            if (state is TicketsChatLoaded && _scrollAfterReload) {
              _scrollAfterReload = false;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _scrollToBottom(),
              );
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              SheetDragAreaWg(
                child: CustomAppBarWg(myTitle: localization.chatTitle),
              ),
              Expanded(
                child: CustomRefreshIndicator(
                  trigger: IndicatorTrigger.trailingEdge,
                  onRefresh: () async => _reload(),
                  child: CustomScrollView(
                    controller: _scrollController,
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                      BlocBuilder<TicketsChatBloc, TicketsChatState>(
                        builder: (context, state) =>
                            _buildMessages(context, state, localization),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildInput(context, localization),
        ),
      ),
    );
  }

  Widget _buildMessages(
    BuildContext context,
    TicketsChatState state,
    AppLocalizations localization,
  ) {
    //! Global bloc boshqa tiketniki bo'lishi mumkin
    final isForThisTicket =
        state is TicketsChatLoaded &&
        (state.listEntity.isEmpty ||
            state.listEntity.first.ticket == widget.ticketId);

    if (state is TicketsChatLoaded && isForThisTicket) {
      final data = state.listEntity;
      if (data.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: AppEmptyState(
              title: localization.noMessagesTitle,
              subtitle: localization.noMessagesSubtitle,
            ),
          ),
        );
      }

      return SliverList.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final position = data.length - 1 - index;
          final item = data[position];
          final showDateHeader =
              position == 0 ||
              !_isSameDay(data[position - 1].createdAt, item.createdAt);
          final hasFile = item.file != null && item.file!.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDateHeader) _DateChip(createdAt: item.createdAt),
              _MessageBubble(
                item: item,
                isMine: _isMine(item),
                hasFile: hasFile,
                isImage:
                    hasFile &&
                    _isImageName(
                      item.fileName.isNotEmpty ? item.fileName : item.file!,
                    ),
                imageUrl: hasFile ? _fullUrl(item.file!) : null,
                heroTag: _heroTag(item),
                isOpeningFile: _openingFiles.contains(item.id),
                onImageTap: (thumbnail) => _openImage(item, thumbnail),
                onFileTap: () => _openFile(item),
              ),
            ],
          );
        },
      );
    }

    if (state is TicketsChatError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionErrorWg(title: state.message, onRetry: _reload),
          ),
        ),
      );
    }

    return const _ChatSkeleton();
  }

  Widget _buildInput(BuildContext context, AppLocalizations localization) {
    //! Klaviatura ochiq bo'lsa pastki safe area kerak emas
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bottom = keyboardOpen ? 0.0 : MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 8,
        bottom: bottom + 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedFile != null)
            _SelectedAttachment(
              file: _selectedFile!,
              isImage: _selectedIsImage,
              onRemove: _removeSelectedFile,
            ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyScale.grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _openAttachSheet,
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
                      hintText: localization.messageHint,
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
    );
  }
}

class _DateChip extends StatelessWidget {
  final String createdAt;

  const _DateChip({required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.greyScale.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(createdAt.toReadableDateWithoutTime()),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final TicketsChatEntity item;
  final bool isMine;
  final bool hasFile;
  final bool isImage;
  final String? imageUrl;
  final Object heroTag;
  final bool isOpeningFile;
  final ValueChanged<ImageProvider> onImageTap;
  final VoidCallback onFileTap;

  const _MessageBubble({
    required this.item,
    required this.isMine,
    required this.hasFile,
    required this.isImage,
    required this.imageUrl,
    required this.heroTag,
    required this.isOpeningFile,
    required this.onImageTap,
    required this.onFileTap,
  });

  static const _imageWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final hasText = item.message.trim().isNotEmpty;
    final showImage = hasFile && isImage;
    final timeStyle = AppTextStyles.source.regular(
      fontSize: 12,
      color: AppColors.greyScale.grey600,
    );

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: EdgeInsets.fromLTRB(isMine ? 48 : 10, 3, isMine ? 10 : 48, 3),
        padding: showImage
            ? const EdgeInsets.all(4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.userChatBackground
              : AppColors.greyScale.grey50,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMine ? 14 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 14),
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showImage) _buildImage(context),
              if (hasFile && !isImage) _buildFileRow(),
              if (hasText)
                Padding(
                  padding: showImage
                      ? const EdgeInsets.fromLTRB(8, 6, 8, 0)
                      : EdgeInsets.only(top: hasFile ? 8 : 0),
                  child: Text(
                    item.message,
                    style: AppTextStyles.source.regular(fontSize: 15),
                  ),
                ),
              Padding(
                padding: showImage
                    ? const EdgeInsets.fromLTRB(8, 4, 8, 2)
                    : const EdgeInsets.only(top: 2),
                child: Text(
                  item.createdAt.toReadableTime(),
                  textAlign: TextAlign.end,
                  style: timeStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final thumbnail = ResizeImage(
      NetworkImage(imageUrl!),
      width: (_imageWidth * dpr).round(),
      policy: ResizeImagePolicy.fit,
    );
    final placeholder = Container(
      width: _imageWidth,
      height: 180,
      color: AppColors.greyScale.grey200,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );

    return GestureDetector(
      onTap: () => onImageTap(thumbnail),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: Hero(
            tag: heroTag,
            child: Image(
              image: thumbnail,
              width: _imageWidth,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : placeholder,
              errorBuilder: (_, _, _) => Container(
                width: _imageWidth,
                height: 140,
                color: AppColors.greyScale.grey200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.greyScale.grey500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileRow() {
    final extension = item.fileExt.replaceAll('.', '').toUpperCase();
    final size = item.fileSize;
    final meta = [
      if (size != null && size > 0) formatFileSize(size),
      if (extension.isNotEmpty) extension,
    ].join(' · ');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onFileTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isOpeningFile
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Icon(_fileIcon(extension), color: AppColors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.fileName.isNotEmpty ? item.fileName : extension,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.source.medium(fontSize: 14),
                ),
                if (meta.isNotEmpty)
                  Text(
                    meta,
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _fileIcon(String extension) => switch (extension) {
    'PDF' => FlutterRemix.file_pdf_line,
    'DOC' || 'DOCX' => FlutterRemix.file_word_line,
    'XLS' || 'XLSX' || 'CSV' => FlutterRemix.file_excel_line,
    'PPT' || 'PPTX' => FlutterRemix.file_ppt_line,
    'TXT' => FlutterRemix.file_text_line,
    _ => FlutterRemix.file_line,
  };
}

class _SelectedAttachment extends StatelessWidget {
  final File file;
  final bool isImage;
  final VoidCallback onRemove;

  const _SelectedAttachment({
    required this.file,
    required this.isImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.greyScale.grey50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.greyScale.grey300),
        ),
        child: Row(
          children: [
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  file,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                ),
              )
            else
              Icon(
                FlutterRemix.file_line,
                size: 22,
                color: AppColors.greyScale.grey600,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                file.path.split('/').last,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                FlutterRemix.close_line,
                size: 20,
                color: AppColors.greyScale.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(label, style: AppTextStyles.source.medium(fontSize: 15)),
    );
  }
}

class _ChatSkeleton extends StatelessWidget {
  const _ChatSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        final isMine = index.isEven;
        return Skeletonizer(
          enabled: true,
          child: Align(
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.6,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isMine ? 'Bu yerda xabar matni bo\'ladi' : 'Qisqaroq xabar',
                    style: AppTextStyles.source.regular(fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '00:00',
                    style: AppTextStyles.source.regular(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
