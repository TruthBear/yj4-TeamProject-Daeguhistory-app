import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final dio = Dio();
  final ip = dotenv.get("SERVER_URL");

  void onChangeEmail(text) {
    setState(() {
      _emailController.text = text;
    });
  }

  void onChangePassword(text) {
    setState(() {
      _passwordController.text = text;
    });
  }

  void login() async {
    try {
      Response response = await dio.post(
        '$ip/api/user/login',
        data: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      String accessToken = response.data["data"]["accessToken"];
      String refreshToken = response.data["data"]["refreshToken"];

      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);


      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.statusCode);
        print(e.response?.data["message"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      onChanged: onChangeEmail,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      onChanged: onChangePassword,
                    ),
                    Text("${_passwordController.text}"),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text("로그인"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
