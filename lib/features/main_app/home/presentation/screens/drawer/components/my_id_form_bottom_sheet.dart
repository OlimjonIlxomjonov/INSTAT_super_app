import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/my_id_configs/my_id_conf.dart';

class PassportInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (i < 2) {
        // First 2 characters must be letters
        if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
          buffer.write(char.toUpperCase());
        } else {
          return oldValue;
        }
      } else if (i < 9) {
        // Next 7 characters must be digits
        if (RegExp(r'[0-9]').hasMatch(char)) {
          buffer.write(char);
        } else {
          return oldValue;
        }
      } else {
        break;
      }
    }

    final newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class MyIdFormBottomSheet extends StatefulWidget {
  const MyIdFormBottomSheet({super.key});

  @override
  State<MyIdFormBottomSheet> createState() => _MyIdFormBottomSheetState();
}

class _MyIdFormBottomSheetState extends State<MyIdFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passportController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _passportController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              onSurface: AppColors.greyScale.grey900,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = "Shaxsni tasdiqlash";
    final passportLabel = "Pasport seriyasi va raqami";
    final birthDateLabel = "Tug'ilgan sana (YYYY-MM-DD)";
    final submitButtonText = "Tasdiqlashni boshlash";

    final fillAllFieldsError = "Barcha maydonlarni to'ldiring";
    final invalidPassportError =
        "Pasport formati noto'g'ri (masalan, AA1234567)";

    return BlocConsumer<FaceRecBloc, FaceRecState>(
      listener: (context, state) async {
        if (state is FaceRecSessionLoaded) {
          // Make sure the keyboard is fully dismissed before handing off
          // to the native SDK / popping the sheet — otherwise it can get
          // stuck showing after the sheet closes.
          FocusManager.instance.primaryFocus?.unfocus();

          // Dynamic session obtained from backend, launch SDK
          final myIdConf = MyIdConf();
          final success = await myIdConf.startFaceVerification(
            context,
            sessionId: state.sessionId,
          );

          if (success) {
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          } else {
            if (context.mounted) {
              // Reset loading spinner on cancel/fail so they can try again
              context.read<FaceRecBloc>().add(ResetFaceRecEvent());
            }
          }
        } else if (state is FaceRecSessionError) {
          errorFlushBar(
            context,
            "Sessiya ID sini olishda xatolik yuz berdi, kiritilgan ma\'lumotlar togriligini tekshiring!",
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is FaceRecSessionLoading;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.greyScale.grey300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.source.bold(fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  // Passport series and number
                  AuthTextFieldWg(
                    label: "AA1234567",
                    title: passportLabel,
                    controller: _passportController,
                    leadingIcon: IconlyLight.document,
                    inputFormatter: [PassportInputFormatter()],
                  ),
                  const SizedBox(height: 15),

                  // Birth Date (DatePicker selector)
                  GestureDetector(
                    onTap: isLoading ? null : () => _selectBirthDate(context),
                    child: AbsorbPointer(
                      child: AuthTextFieldWg(
                        label: "YYYY-MM-DD",
                        title: birthDateLabel,
                        controller: _birthDateController,
                        leadingIcon: IconlyLight.calendar,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Submit button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // Unfocus first — this both dismisses the
                              // keyboard immediately and avoids the stuck
                              // keyboard issue seen when navigating away
                              // later in the flow.
                              FocusManager.instance.primaryFocus?.unfocus();

                              final passport = _passportController.text.trim();
                              final birthDate = _birthDateController.text
                                  .trim();

                              if (passport.isEmpty || birthDate.isEmpty) {
                                errorFlushBar(context, fillAllFieldsError);
                                return;
                              }

                              final passportRegex = RegExp(
                                r'^[a-zA-Z]{2}[0-9]{7}$',
                              );
                              if (!passportRegex.hasMatch(passport)) {
                                errorFlushBar(context, invalidPassportError);
                                return;
                              }

                              context.read<FaceRecBloc>().add(
                                GetMyIdSessionEvent(
                                  birthDate: birthDate,
                                  passportData: passport.toUpperCase(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              submitButtonText,
                              style: AppTextStyles.source.medium(fontSize: 15),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
