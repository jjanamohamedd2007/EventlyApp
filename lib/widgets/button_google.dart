import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../models/firebase_auth_model.dart';

class ButtonGoogle extends StatelessWidget {

  const ButtonGoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 361,
        height: 56,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: AppColors.primary,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () async {
            try {
              final userCredential = await AuthService.signInWithGoogle();

              final user = userCredential?.user;

              print('تم تسجيل الدخول: ${user?.displayName}');
              print('الإيميل: ${user?.email}');


            } catch (e) {
              print('حدث خطأ أثناء تسجيل الدخول: $e');
            }
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/googleIcon.png"
              ),
              const SizedBox(width: 10),
              Text(
                tr("login_with_google"),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
