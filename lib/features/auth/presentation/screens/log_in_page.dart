import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/theme/custom_themes/app_text_theme.dart';
import 'package:my_template/features/app_bottom_nav_bar.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: appW(20)),
        child: Center(
          child: Column(
            crossAxisAlignment: .start,
            spacing: appH(20),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Log in', style: TTextTheme.lightTextTheme.titleLarge),
              AuthTextFieldWg(label: 'Email', controller: emailController),
              AuthTextFieldWg(
                label: 'Password',
                isPassword: true,
                controller: passwordController,
              ),
              ElevatedButton(
                onPressed: () {
                  AppRoute.open(AppBottomNavBar());
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
