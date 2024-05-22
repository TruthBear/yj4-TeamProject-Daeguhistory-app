import 'package:flutter/material.dart';
import 'package:project/src/utils/secure_storage.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("프로필임");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoreScreen(),
                ),
              );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("내 정보"),
          ],
        ),
      ),
    );
  }
}

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  void logout() async {
    await storage.delete(key: ACCESS_TOKEN_KEY);
    await storage.delete(key: REFRESH_TOKEN_KEY);

    Navigator.pushNamedAndRemoveUntil(
      context,
      'login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: logout,
          child: Text("로그아웃"),
        ),
      ),
    );
  }
}
