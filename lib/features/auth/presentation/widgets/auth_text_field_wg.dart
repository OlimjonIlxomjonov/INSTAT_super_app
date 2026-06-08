import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

import '../../../../core/utils/app_utils.dart';

class AuthTextFieldWg extends StatefulWidget {
  final String label;
  final bool? isPassword;
  final IconData? leadingIcon;
  final TextEditingController controller;
  final String? title;
  final Function(String)? onChanged;
  final bool isTypeNum;
  final Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatter;

  const AuthTextFieldWg({
    super.key,
    required this.label,
    this.isPassword,
    required this.controller,
    this.leadingIcon,
    this.title,
    this.onChanged,
    this.isTypeNum = false,
    this.onEditingComplete,
    this.inputFormatter,
  });

  @override
  State<AuthTextFieldWg> createState() => _AuthTextFieldWgState();
}

class _AuthTextFieldWgState extends State<AuthTextFieldWg> {
  bool obscureVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (widget.title != null)
          Text(widget.title!, style: CustomTextStyles.h3half),
        SizedBox(height: 8),
        TextField(
          keyboardType: widget.isTypeNum ? TextInputType.number : null,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          controller: widget.controller,
          inputFormatters: widget.inputFormatter,
          obscureText: widget.isPassword ?? false ? obscureVisibility : false,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder().copyWith(
              borderRadius: .circular(10),
              borderSide: BorderSide(
                color: AppColors.greyScale.grey300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder().copyWith(
              borderRadius: .circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
            ),
            prefixIcon: widget.leadingIcon != null
                ? Icon(widget.leadingIcon)
                : null,
            hintText: widget.label,

            suffixIcon: widget.isPassword ?? false
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscureVisibility = !obscureVisibility;
                      });
                    },
                    icon: Icon(
                      obscureVisibility ? IconlyLight.hide : IconlyLight.show,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
