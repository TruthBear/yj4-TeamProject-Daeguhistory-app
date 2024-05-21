import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("프로필임");
    return Scaffold(
      body: Center(
        child: Text("프로필"),
      ),
    );
  }
}
