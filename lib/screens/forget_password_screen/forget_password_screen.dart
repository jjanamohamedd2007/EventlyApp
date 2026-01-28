import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/base_theme.dart';
import '../../models/fire_base/firebase_manager.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_form_field_widget.dart';
import '../../providers/my_provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = "forget";

  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    final bool isDark = provider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.primary,
        ),
        title: Text(
          tr("forget_password"),
          style: TextStyle(
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
      body: Form(
        key: formKey,

        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset("assets/images/resetPassword.png"),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  hintText: tr("email"),
                  textInputType: TextInputType.emailAddress,
                  imageField: "assets/images/email.png",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email_required'.tr();
                    }

                    if (!value.endsWith('@gmail.com')) {
                      return 'email_invalid_domain'.tr();
                    }

                    String namePart = value.split('@')[0];
                    if (namePart.isEmpty) {
                      return 'email_invalid_name'.tr();
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Button_Widget(
                    text: tr("reset_password"),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();

                      if (formKey.currentState!.validate()) {
                        try {
                          await FirebaseManager.resetPassword(
                            emailController.text,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'reset_password_success'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'reset_password_error'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
