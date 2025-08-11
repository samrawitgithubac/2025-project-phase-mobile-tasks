// lib/features/auth/presentation/pages/splash_page.dart

import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is now just a simple UI widget with NO logic.
    return Scaffold(
      backgroundColor: const Color(0xFF4A47E4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'ECOM',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A47E4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ECOMMERCE APP',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
