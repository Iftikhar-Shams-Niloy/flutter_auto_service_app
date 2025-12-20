import 'package:flutter/material.dart';
import 'package:flutter_auto_service_app/main.dart';
import 'package:flutter_auto_service_app/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Logo image
                Image.asset(
                  'assets/images/splash_image.png',
                  width: 360,
                  fit: BoxFit.contain,
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Image(
                    image: AssetImage("assets/images/find.png"),
                    height: 60,
                    width: 160,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          SizedBox(
            width: double.infinity,
            height: 92,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthWrapper()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Let's go",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  Image.asset(
                    "assets/images/right_sign.png",
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
