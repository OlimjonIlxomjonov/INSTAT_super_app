import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/academic_degree/academic_degree_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/academic_degree/academic_degree_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class ArticleAddAuthorView extends StatefulWidget {
  const ArticleAddAuthorView({super.key});

  @override
  State<ArticleAddAuthorView> createState() => _ArticleAddAuthorViewState();
}

class _ArticleAddAuthorViewState extends State<ArticleAddAuthorView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _orcidController = TextEditingController();
  int? _selectedDegreeId;
  int? _editingAuthorId;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _organizationController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _orcidController.dispose();
    super.dispose();
  }

  void _saveAuthor() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final organization = _organizationController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final orcid = _orcidController.text.trim();

    if (firstName.isEmpty) {
      _showError("Muallif ismini kiriting");
      return;
    }
    if (lastName.isEmpty) {
      _showError("Muallif familiyasini kiriting");
      return;
    }
    if (_selectedDegreeId == null) {
      _showError("Ilmiy darajani tanlang");
      return;
    }
    if (organization.isEmpty) {
      _showError("Tashkilotni kiriting");
      return;
    }
    if (email.isEmpty) {
      _showError("Elektron pochtani kiriting");
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showError("Yaroqsiz elektron pochta manzili");
      return;
    }
    if (address.isEmpty) {
      _showError("Shahar, davlatni kiriting");
      return;
    }
    if (phoneNumber.isEmpty) {
      _showError("Telefon raqamini kiriting");
      return;
    }

    final reviewId = context.read<AddArticleBloc>().state.reviewId ?? 0;

    final authorParams = ReviewAuthorParams(
      id: _editingAuthorId,
      firstName: firstName,
      lastName: lastName,
      review: reviewId,
      academicDegree: _selectedDegreeId!,
      address: address,
      organization: organization,
      email: email,
      phoneNumber: phoneNumber,
      orcidCode: orcid.isNotEmpty ? orcid : null,
    );

    if (_editingAuthorId != null) {
      context.read<AddArticleBloc>().add(
        UpdateReviewAuthorEvent(
          author: authorParams,
          onSuccess: () {
            _clearFields();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Muallif muvaffaqiyatli yangilandi'),
              ),
            );
          },
          onError: (err) {
            _showError('Muallifni yangilashda xatolik: $err');
          },
        ),
      );
      return;
    }

    if (reviewId == 0) {
      // Review is not created on server yet, save locally
      context.read<AddArticleBloc>().add(
        AddLocalAuthorEvent(author: authorParams),
      );
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Muallif ro'yxatga qo'shildi (mahalliy)")),
      );
    } else {
      // Review exists on server, POST immediately
      context.read<AddArticleBloc>().add(
        CreateReviewAuthorEvent(
          author: authorParams,
          onSuccess: () {
            _clearFields();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Muallif muvaffaqiyatli saqlandi")),
            );
          },
          onError: (err) {
            _showError("Muallifni saqlashda xatolik: $err");
          },
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.red),
    );
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _organizationController.clear();
    _emailController.clear();
    _addressController.clear();
    _phoneNumberController.clear();
    _orcidController.clear();
    setState(() {
      _selectedDegreeId = null;
      _editingAuthorId = null;
    });
  }

  void _startEditingAuthor(ReviewAuthorEntity author) {
    setState(() {
      _editingAuthorId = author.id;
      _firstNameController.text = author.firstName;
      _lastNameController.text = author.lastName;
      _organizationController.text = author.organization;
      _emailController.text = author.email;
      _addressController.text = author.address;
      _phoneNumberController.text = author.phoneNumber;
      _orcidController.text = author.orcidCode;
      _selectedDegreeId = author.academicDegree?.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          spacing: 14,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? NAME
            AuthTextFieldWg(
              label: 'Muallif ismi',
              title: 'Ismi',
              controller: _firstNameController,
              leadingIcon: IconlyLight.profile,
            ),

            //? SURNAME
            AuthTextFieldWg(
              label: 'Muallif familiyasi',
              title: 'Familiya',
              controller: _lastNameController,
              leadingIcon: IconlyLight.profile,
            ),

            //? DEGREE
            BlocBuilder<AcademicDegreeBloc, AcademicDegreeState>(
              builder: (context, state) {
                final loaded = state is AcademicDegreeLoaded
                    ? state.entity
                    : null;
                return CustomDropDownMenuWg(
                  title: 'Ilmiy Daraja',
                  hintText: 'Ilmiy daraja',
                  leadingIcon: Icons.school_outlined,
                  options: loaded,
                  value: _selectedDegreeId,
                  onChanged: (val) {
                    setState(() {
                      _selectedDegreeId = val;
                    });
                  },
                );
              },
            ),

            //? COMPANY
            AuthTextFieldWg(
              label: 'Tashkilot nomini yozing',
              title: 'Tashkilot',
              controller: _organizationController,
              leadingIcon: Icons.corporate_fare,
            ),

            /// email
            AuthTextFieldWg(
              label: 'example@gmail.com',
              title: 'Elektron pochta',
              controller: _emailController,
              leadingIcon: IconlyLight.message,
            ),

            /// address
            AuthTextFieldWg(
              label: 'Toshkent, O\'zbekiston',
              title: 'Shahar, davlat',
              controller: _addressController,
              leadingIcon: IconlyLight.location,
            ),

            /// phone number
            IntlPhoneField(
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: Colors.white,
              ),
              controller: _phoneNumberController,
              showCountryFlag: false,
              flagsButtonPadding: const EdgeInsets.only(left: 8.0),
              decoration: InputDecoration(
                hintText: 'Telefon raqami',
                enabledBorder: OutlineInputBorder(
                  borderRadius: .circular(10),
                  borderSide: BorderSide(
                    color: AppColors.greyScale.grey300,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: .circular(10),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.0,
                  ),
                ),
              ),
              initialCountryCode: 'UZ',
              showDropdownIcon: true,
              dropdownIcon: Icon(IconlyLight.call),
              onChanged: (phone) {},
            ),

            /// ORCID
            AuthTextFieldWg(
              label: '0000 0000 0000 0000 ID',
              title: 'ORCID',
              controller: _orcidController,
              leadingIcon: LineIcons.identificationCard,
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                _OrcidInputFormatter(),
              ],
            ),

            const SizedBox(height: 10),

            //? SAVE AUTHOR BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveAuthor,
              child: Center(
                child: Text(
                  _editingAuthorId != null
                      ? 'Muallifni yangilash'
                      : 'Muallifni saqlash',
                  style: AppTextStyles.source.medium(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (_editingAuthorId != null) ...[
              TextButton(
                onPressed: _clearFields,
                child: const Text('Tahrirlashni bekor qilish'),
              ),
            ],

            //? AUTHORS LIST SECTION
            BlocBuilder<AddArticleBloc, AddArticleState>(
              builder: (context, addState) {
                final hasLocal = addState.localAuthors.isNotEmpty;
                final hasSaved = addState.savedAuthors.isNotEmpty;

                if (!hasLocal && !hasSaved) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text("Kiritilgan mualliflar", style: CustomTextStyles.h2),
                    const SizedBox(height: 10),
                    // Render local authors
                    ...addState.localAuthors.asMap().entries.map((entry) {
                      final index = entry.key;
                      final author = entry.value;
                      return _AuthorListCard(
                        name: "${author.firstName} ${author.lastName}",
                        email: author.email,
                        isLocal: true,
                        onDelete: () {
                          context.read<AddArticleBloc>().add(
                            RemoveLocalAuthorEvent(index: index),
                          );
                        },
                      );
                    }),
                    // Render saved authors
                    ...addState.savedAuthors.map((author) {
                      return _AuthorListCard(
                        name: "${author.firstName} ${author.lastName}",
                        email: author.email,
                        isLocal: false,
                        isEditing: _editingAuthorId == author.id,
                        onEdit: () => _startEditingAuthor(author),
                      );
                    }),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _OrcidInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('-', '');
    if (digits.length > 16) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('-');
      buffer.write(digits[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _AuthorListCard extends StatelessWidget {
  final String name;
  final String email;
  final bool isLocal;
  final bool isEditing;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _AuthorListCard({
    required this.name,
    required this.email,
    required this.isLocal,
    this.isEditing = false,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isEditing
            ? AppColors.primaryColor.withValues(alpha: 0.06)
            : AppColors.greyScale.grey50,
        border: Border.all(
          color: isEditing
              ? AppColors.primaryColor
              : AppColors.greyScale.grey200,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
            child: Icon(Icons.person, color: AppColors.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.source.medium(
                    fontSize: 14,
                    color: AppColors.greyScale.grey800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey500,
                  ),
                ),
              ],
            ),
          ),
          if (isLocal) ...[
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppColors.red,
              onPressed: onDelete,
            ),
          ],
          if (!isLocal && onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.primaryColor,
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
