import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AuthTextFieldWg extends StatefulWidget {
  final String label;
  final bool? isPassword;
  final TextEditingController controller;

  const AuthTextFieldWg({
    super.key,
    required this.label,
    this.isPassword,
    required this.controller,
  });

  @override
  State<AuthTextFieldWg> createState() => _AuthTextFieldWgState();
}

class _AuthTextFieldWgState extends State<AuthTextFieldWg> {
  bool obscureVisibility = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ?? false ? obscureVisibility : false,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.isPassword ?? false ? IconlyLight.lock : IconlyLight.profile,
        ),
        labelText: widget.label,
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
    );
  }
}
