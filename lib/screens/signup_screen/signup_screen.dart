import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/models/fire_base/firebase_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/base_theme.dart';
import '../../core/theme/dark_theme.dart';
import '../../core/theme/light_theme.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/image_header_widget.dart';
import '../../widgets/text_form_field_widget.dart';
import '../../providers/my_provider.dart';
import '../../widgets/toggle_language.dart';
import '../login_screen/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = "signup";

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final bool isDark = provider.themeMode == ThemeMode.dark;

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
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
          title: Text(
            tr("register"),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: isDark
              ? BaseTheme.dark.scaffoldBackgroundColor
              : BaseTheme.light.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const ImageHeaderWidget(),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("name_required");
                      } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return tr("name_letters_only");
                      } else if (value.trim().length < 6) {
                        return tr("name_min_length");
                      }
                      return null;
                    },
                    hintText: tr("name"),
                    textInputType: TextInputType.name,
                    imageField: "assets/images/person.png",
                  ),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("location_required");
                      } else if (value.trim().length < 3) {
                        return tr("location_min_length");
                      }
                      return null;
                    },
                    hintText: tr("Location"),
                    textInputType: TextInputType.text,
                    imageField: "assets/images/Map_Pin.png",
                  ),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: emailController,
                    hintText: tr("email"),
                    textInputType: TextInputType.emailAddress,
                    imageField: "assets/images/email.png",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr("email_required");
                      } else if (!value.contains('@')) {
                        return tr("email_must_contain_at");
                      } else if (!RegExp(
                        r"^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9@._-]+$",
                      ).hasMatch(value)) {
                        return tr("email_must_contain_letters_numbers");
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      ).hasMatch(value)) {
                        return tr("email_invalid_format");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: passwordController,
                    hintText: tr("password"),
                    textInputType: TextInputType.visiblePassword,
                    imageField: "assets/images/password.png",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr("password_required");
                      } else if (!RegExp(
                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$',
                      ).hasMatch(value)) {
                        return tr("password_letters_numbers_only");
                      } else if (value.length < 6) {
                        return tr("password_min_length");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: rePasswordController,
                    hintText: tr("re_password"),
                    textInputType: TextInputType.visiblePassword,
                    imageField: "assets/images/password.png",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr("re_password_required");
                      } else if (value != passwordController.text) {
                        return tr("passwords_not_match");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  Button_Widget(
                    text: tr("create_account"),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        await FirebaseManager.createUser(
                          nameController.text,
                          locationController.text,
                          emailController.text,
                          passwordController.text,
                              () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 8,
                                titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                title: Row(
                                  children: [
                                    Icon(Icons.email_outlined,
                                        color: AppColors.primary, size: 26),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Verify your email",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  "Your account has been created successfully.\nWe've sent a verification link to your email. Please verify it before logging in.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        LoginScreen.routeName,
                                            (route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                              (message) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 8,
                                titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                title: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: AppColors.primary, size: 26),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Something went wrong",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.7),
                                    height: 1.4,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actionsPadding: const EdgeInsets.only(bottom: 10),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                              () {},
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        LoginScreen.routeName,
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                            "${tr("already_have_account_login",).split("?")[0]}?",
                            style: (isDark ? DarkTheme.linkText : LightTheme.linkText)
                                .copyWith(),                          ),
                          TextSpan(
                            text: " ${tr("login")}",
                            style: LightTheme.italicText.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Center(child: ToggleLanguage()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
