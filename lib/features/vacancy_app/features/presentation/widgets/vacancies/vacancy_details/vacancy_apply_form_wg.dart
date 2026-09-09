import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/date_picker_sheet/date_picker_sheet.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_form_field_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_input_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_picker_field_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';

const Set<String> _allowedExtensions = {'jpeg', 'jpg', 'png', 'pdf', 'mp4'};
const int _maxFileSizeBytes = 50 * 1024 * 1024;

class VacancyApplyFormWg extends StatefulWidget {
  const VacancyApplyFormWg({super.key});

  @override
  State<VacancyApplyFormWg> createState() => _VacancyApplyFormWgState();
}

class _VacancyApplyFormWgState extends State<VacancyApplyFormWg> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime? _birthDate;
  File? _file;
  String? _fileName;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePickerSheet(
      context,
      title: 'Tug’ilgan sana',
      initialDate: _birthDate ?? DateTime(2001),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickFile() async {
    final picked = await ArticleFilePickerHelper.pickFiles(
      allowedExtensions: _allowedExtensions,
      allowMultiple: false,
      invalidExtensionMessage: 'JPEG, PNG, PDF yoki MP4 fayl tanlang',
      noFileChosenMessage: 'Fayl tanlanmadi',
      pickErrorMessage: 'Faylni tanlashda xatolik',
    );
    if (picked.isEmpty) return;

    final chosen = picked.first;
    if (await chosen.file.length() > _maxFileSizeBytes) return;

    setState(() {
      _file = chosen.file;
      _fileName = chosen.name;
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          //! Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.greyScale.grey200),
                    ),
                    child: Icon(
                      FlutterRemix.chat_1_line,
                      size: 20,
                      color: AppColors.greyScale.grey700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ariza yuborish',
                          style: AppTextStyles.source.semiBold(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ma’lumotlaringizni kiriting',
                          style: AppTextStyles.source.regular(
                            fontSize: 13,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.close, color: AppColors.greyScale.grey700),
                  ),
                ],
              ),
            ),
          ),

          //! Form
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppFormFieldWg(
                    label: 'F.I.SH',
                    isRequired: true,
                    child: AppInputWg(
                      controller: _fullNameController,
                      hintText: 'Karimov Azizbek Anvarovich',
                    ),
                  ),
                  AppFormFieldWg(
                    label: 'Tug’ilgan sana',
                    isRequired: true,
                    child: AppPickerFieldWg(
                      hintText: '01.01.2001',
                      value: _birthDate == null
                          ? null
                          : _formatDate(_birthDate!),
                      trailingIcon: FlutterRemix.calendar_line,
                      onTap: _pickBirthDate,
                    ),
                  ),
                  AppFormFieldWg(
                    label: 'Telefon raqam',
                    isRequired: true,
                    child: AppInputWg(
                      controller: _phoneController,
                      hintText: '+998 (--) --- -- -',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  AppFormFieldWg(
                    label: 'Email',
                    isRequired: true,
                    child: AppInputWg(
                      controller: _emailController,
                      hintText: 'azizbek.karimov@stat.uz',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  //! Fayl
                  const SizedBox(height: 4),
                  VacancySectionTitleWg(title: 'Fayl yuklash'),
                  const SizedBox(height: 12),
                  DottedContainerWg(
                    onTap: _pickFile,
                    formatsHint:
                        'JPEG, PNG, PDF, and MP4 formats, up to 50 MB.',
                  ),
                  if (_file != null) ...[
                    const SizedBox(height: 12),
                    SelectedFileContainerWg(
                      fileName: _fileName,
                      fileSize: formatFileSize(_file!.lengthSync()),
                      onRemove: () => setState(() {
                        _file = null;
                        _fileName = null;
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: 'Davom etish',
        onTap: () {},
      ),
    );
  }
}
