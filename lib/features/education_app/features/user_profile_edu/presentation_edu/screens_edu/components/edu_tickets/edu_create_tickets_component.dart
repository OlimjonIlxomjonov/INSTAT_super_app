import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/create_tickets/create_tickets_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/create_tickets/create_tickets_state.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';

import '../../../../../../../../core/common/params/edu_params/params.dart';
import '../../../../../home_edu/presentation_edu/bloc/home_edu_event.dart';

class EduCreateTicketsComponent extends StatefulWidget {
  const EduCreateTicketsComponent({super.key});

  @override
  State<EduCreateTicketsComponent> createState() =>
      _EduCreateTicketsComponentState();
}

class _EduCreateTicketsComponentState extends State<EduCreateTicketsComponent> {
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketDescController = TextEditingController();
  File? _selectedFile;

  @override
  void dispose() {
    _ticketDescController.dispose();
    _ticketNameController.dispose();
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

  void _handleSubmit(AppLocalizations localization) {
    final title = _ticketNameController.text.trim();
    final desc = _ticketDescController.text.trim();

    if (title.isEmpty) {
      errorFlushBar(context, 'Ticket nomi va file majburiy!');
      return;
    }
    if (_selectedFile == null) {
      errorFlushBar(context, 'Iltimos, fayl biriktiring');
      return;
    }

    context.read<CreateTicketsBloc>().add(
      CreateTicketsEvent(
        params: CreateTicketParams(
          title: title,
          desc: desc.isEmpty ? null : desc,
          file: _selectedFile!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocListener<CreateTicketsBloc, CreateTicketsState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is CreateTicketsLoaded) {
          _ticketNameController.clear();
          _ticketDescController.clear();

          setState(() {
            _selectedFile = null;
          });

          successFlushBar(context, 'Tikket yaratildi');
        } else if (state is CreateTicketsError) {
          errorFlushBar(context, 'Ticket yaratilmadi');
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: SheetDragAreaWg(
                  child: CustomAppBarWg(
                    myTitle: localization.createTicketTitle,
                    isFamily: true,
                  ),
                ),
              ),
              SliverPadding(
                padding: AppPadding.hAndV20x20(),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! TICKET NAME
                      Text(
                        localization.ticketNameLabel,
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      EduCustomTextAreaWg(
                        hintText: localization.subjectHint,
                        controller: _ticketNameController,
                      ),
                      const SizedBox(height: 12),
                      //! DESC
                      Text(
                        localization.commentFieldLabel,
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      EduCustomTextAreaWg(
                        hintText: localization.commentHint,
                        controller: _ticketDescController,
                      ),

                      const SizedBox(height: 20),

                      //! FILE
                      if (_selectedFile == null)
                        DottedContainerWg(
                          onTap: _pickFile,
                          formatsHint:
                              'JPEG, PNG, PDF va MP4 formatlar, 50 MB gacha',
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.greyScale.grey50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.greyScale.grey300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.insert_drive_file_outlined,
                                color: AppColors.greyScale.grey600,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _selectedFile!.path.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.source.medium(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _removeSelectedFile,
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.greyScale.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //! CONFIRM
          bottomNavigationBar:
              BlocBuilder<CreateTicketsBloc, CreateTicketsState>(
                builder: (context, state) {
                  final isLoading = state is CreateTicketsLoading;
                  return CustomBottomNavContainerWg(
                    buttonText: isLoading
                        ? 'Yuborilmoqda...'
                        : localization.confirm,
                    anotherButton: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greyScale.grey50,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => FamilyNavigation.familyClose(context),
                      child: Icon(Icons.close, color: AppColors.black),
                    ),
                    onTap: isLoading
                        ? () {}
                        : () => _handleSubmit(localization),
                  );
                },
              ),
        ),
      ),
    );
  }
}
