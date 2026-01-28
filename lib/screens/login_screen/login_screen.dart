import 'dart:ui';

import 'package:evently_app/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/base_theme.dart';
import '../../core/theme/dark_theme.dart';
import '../../core/theme/light_theme.dart';
import '../../widgets/button_google.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/image_header_widget.dart';
import '../../widgets/text_form_field_widget.dart';
import '../../widgets/toggle_language.dart';
import '../../providers/my_provider.dart';
import '../forget_password_screen/forget_password_screen.dart';
import '../signup_screen/signup_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/models/fire_base/firebase_manager.dart';
import 'package:evently_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    var auth = Provider.of<AuthProvider>(context);

    final bool isDark = provider.themeMode == ThemeMode.dark;
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark
            ? BaseTheme.dark.scaffoldBackgroundColor
            : BaseTheme.light.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark
            ? BaseTheme.dark.scaffoldBackgroundColor
            : BaseTheme.light.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ImageHeaderWidget(),
                const SizedBox(height: 20),

                TextFormFieldWidget(
                  hintText: tr("email"),
                  textInputType: TextInputType.emailAddress,
                  imageField: "assets/images/email.png",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormFieldWidget(
                  hintText: tr("password"),
                  textInputType: TextInputType.visiblePassword,
                  imageField: "assets/images/password.png",
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ForgetPasswordScreen.routeName,
                      );
                    },
                    child: Text(
                      tr("forget_password"),
                      style:
                      (isDark ? DarkTheme.italicText : LightTheme.italicText)
                          .copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button_Widget(
                    text: tr("login"),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          try {
                            await FirebaseManager.logIn(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                                  () async {
                                await auth.initUser();
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.routeName,
                                      (route) => false,
                                );
                              },
                                  (message) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: Colors.red.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    content: Row(
                                      children: [
                                        const Icon(Icons.error_outline, color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            message,
                                            style: const TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              },
                                  () {},
                            );
                          } catch (e) {
                            Navigator.pop(context);
                          }
                        }
                      }

                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupScreen.routeName);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                          "${tr("dont_have_account_create_account").split("?")[0]}?",
                          style: (isDark ? DarkTheme.linkText : LightTheme.linkText)
                              .copyWith(),
                        ),
                        TextSpan(
                          text: " ${tr("create_account")}",
                          style:
                          (isDark ? DarkTheme.italicText : LightTheme.italicText)
                              .copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.primary,
                        thickness: 1,
                        endIndent: 10,
                        indent: 20,
                      ),
                    ),
                    Text(tr("or"), style: TextStyle(color: AppColors.primary)),
                    Expanded(
                      child: Divider(
                        color: AppColors.primary,
                        thickness: 1,
                        indent: 10,
                        endIndent: 20,
                      ),
                    ),
                  ],
                ),

                ButtonGoogle(),
                Center(child: ToggleLanguage()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
