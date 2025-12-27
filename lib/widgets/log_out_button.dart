import 'package:evently_app/core/theme/app_colors.dart';
import 'package:evently_app/models/fire_base/firebase_manager.dart';
import 'package:evently_app/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () async {
            await FirebaseManager.logOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginScreen.routeName,
                  (route) => false,
            );
          },
          child: Row(
            children: [
              Image.asset(
                "assets/images/Exit.png",
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
