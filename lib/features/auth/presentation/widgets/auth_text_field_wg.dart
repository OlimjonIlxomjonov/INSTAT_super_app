import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class AuthTextFieldWg extends StatefulWidget {
  final String label;
  final bool? isPassword;
  final IconData? leadingIcon;
  final TextEditingController controller;
  final String? title;

  const AuthTextFieldWg({
    super.key,
    required this.label,
    this.isPassword,
    required this.controller,
    this.leadingIcon,
    this.title,
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
          controller: widget.controller,
          obscureText: widget.isPassword ?? false ? obscureVisibility : false,
          decoration: InputDecoration(
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
