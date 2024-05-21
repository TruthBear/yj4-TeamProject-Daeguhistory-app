import 'package:flutter/material.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("사전임");
    return Scaffold(
      body: Center(
        child: Text("사전"),
      ),
    );
  }
}
