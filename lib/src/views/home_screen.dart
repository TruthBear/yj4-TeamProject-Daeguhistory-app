import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("홈임");
    return Scaffold(
      body: Center(
        child: Text("홈인"),
      ),
    );
  }
}
