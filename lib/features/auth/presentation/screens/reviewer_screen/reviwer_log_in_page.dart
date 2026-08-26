import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/features/auth/presentation/bloc/reviewer_login/reviewer_login_bloc.dart';
import 'package:my_template/features/auth/presentation/bloc/reviewer_login/reviewer_login_event.dart';
import 'package:my_template/features/auth/presentation/bloc/reviewer_login/reviewer_login_state.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';

class ReviewerLogInPage extends StatefulWidget {
  const ReviewerLogInPage({super.key});

  @override
  State<ReviewerLogInPage> createState() => _ReviewerLogInPageState();
}

class _ReviewerLogInPageState extends State<ReviewerLogInPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ReviewerLoginBloc>().add(
            SubmitReviewerLoginEvent(
              username: _usernameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewerLoginBloc>(
      create: (_) => sl<ReviewerLoginBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<ReviewerLoginBloc, ReviewerLoginState>(
              listener: (context, state) {
                if (state is ReviewerLoginError) {
                  errorFlushBar(context, state.message);
                } else if (state is ReviewerLoginSuccess) {
                  AppRoute.open(const HomePage());
                }
              },
              builder: (context, state) {
                final isLoading = state is ReviewerLoginLoading;

                return Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppBarWg(myTitle: 'Reviewer Log in', showArrow: true),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _usernameController,
                            enabled: !isLoading,
                            style: AppTextStyles.source.regular(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Username or Email',
                              hintText: 'Enter username',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.greyScale.grey600,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.greyScale.grey400),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isPasswordObscured,
                            enabled: !isLoading,
                            style: AppTextStyles.source.regular(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter password',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppColors.greyScale.grey600,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.greyScale.grey600,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColors.greyScale.grey400),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: isLoading ? null : () => _onLoginPressed(context),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Submit',
                                      style: AppTextStyles.source.semiBold(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
