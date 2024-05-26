import 'package:flutter/material.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/views/login_and_register/login_screen.dart';
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
                    child: Text("대구의 유구한 역사와 문화를"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CustomTextButton(
                        onPressed: () {},
                        buttonText: "이메일로 시작하기",
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        width: double.infinity,
                        height: 45,
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
