import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "스플래쉬 스크린임",
                style: TextStyle(fontSize: 30),
              ),
              CircularProgressIndicator(
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}
