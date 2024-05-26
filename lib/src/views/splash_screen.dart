import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/secure_storage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
      Duration(seconds: 1),
      isLogin
    );
  }

  void moveToScreen({required route}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
          (route) => false,
    );
  }

  void isLogin() async {
    final dio = Dio();
    final ip = dotenv.get("SERVER_URL");
    String? token = await storage.read(key: REFRESH_TOKEN_KEY);
    if (token != null) {
      // 리프레쉬 토큰이 있을시
      try{
        Response response = await dio.post(
          '$ip/api/oauth/token',
          options: Options(
              headers: {
                "Authorization": "Bearer $token",
              }
          ),
        );

        String accessToken = response.data["accessToken"];
        String refreshToken = response.data["refreshToken"];

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

        moveToScreen(route: "/");

      } on DioException catch(e) {
        // 리프레쉬 토큰이 만료가 되었으면 로그인 화면으로
        print(e.response?.data);
        moveToScreen(route: "login");
      }
    } else {
      // 리프레쉬 토큰이 없을 시
      moveToScreen(route: "login");
    }
  }

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
