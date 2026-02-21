import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/logo.png',
            //   width: 150,
            //   height: 150,
            // ),
            Icon(Icons.shopping_cart, size: 100, color: Colors.blue),
            const SizedBox(height: 24),

            const Text(
              'E-Commerce',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
