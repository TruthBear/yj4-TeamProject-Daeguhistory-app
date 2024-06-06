import 'package:flutter/material.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/utils/my_flutter_app_icons.dart';
import 'package:project/src/views/login_and_register/login_screen.dart';
import 'package:project/src/views/login_and_register/register_email_screen.dart';
import 'package:project/src/weiget/custom_text_button.dart';

class SelectLoginScreen extends StatelessWidget {
  const SelectLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/logo.png"),
                        Text("대구의 유구한 역사와 문화를", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        Text("쉽고 재미있게 배워보세요", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CustomTextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterEmailScreen(),
                            ),
                          );
                        },
                        buttonText: "이메일로 시작하기",
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        width: double.infinity,
                        height: 45,
                        icon: Icon(Icons.email_outlined),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextButton(
                        onPressed: () {},
                        buttonText: "카카오로 시작하기",
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        width: double.infinity,
                        height: 45,
                        icon: Icon(MyFlutterApp.vector),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextButton(
                        onPressed: () {},
                        buttonText: "Google로 시작하기",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        width: double.infinity,
                        height: 45,
                        side: BorderSide(color: Colors.black, width: 1),
                        icon: Icon(MyFlutterApp.google, color: PRIMARY_COLOR,),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen(),
                            ),
                          );
                        },
                        buttonText: "로그인",
                        foregroundColor: Colors.black,
                        height: 45,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
