import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/utils/secure_storage.dart';
import 'package:project/src/weiget/custom_text_button.dart';
import 'package:project/src/weiget/custom_text_form_field.dart';

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

  bool hasTextFieldValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController.addListener(_updateHasTextFieldValue);
    _passwordController.addListener(_updateHasTextFieldValue);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.removeListener(_updateHasTextFieldValue);
    _passwordController.removeListener(_updateHasTextFieldValue);
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _updateHasTextFieldValue() {
    setState(() {
      hasTextFieldValue = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
    print(hasTextFieldValue);
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

  void oo() async {
   final abc = await storage.read(key: REFRESH_TOKEN_KEY);
   print("토큰:$abc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: BACKGROUND_COLOR,
        title: Text(
          "로그인",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: "이메일",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: "비밀번호",
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomTextButton(
                    width: double.infinity,
                    height: 45,
                    onPressed: hasTextFieldValue ? login : null,
                    buttonText: "로그인",
                    backgroundColor: hasTextFieldValue
                        ? PRIMARY_COLOR
                        : PRIMARY_COLOR.withOpacity(0.15),
                    foregroundColor: Colors.white,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomTextButton(
                    onPressed: () {},
                    buttonText: "비밀번호를 잊으셨나요?",
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: oo,
                child: Text("토큰 확인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
