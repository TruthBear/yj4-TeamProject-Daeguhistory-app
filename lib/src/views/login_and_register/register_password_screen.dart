import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/src/views/login_and_register/register_name_screen.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/provider_state.dart';
import '../../weiget/custom_text_button.dart';
import '../../weiget/custom_text_form_field.dart';

class RegisterPasswordScreen extends StatefulWidget {
  const RegisterPasswordScreen({super.key});

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();

  bool hasTextFieldValue = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _passwordController.addListener(_updateHasTextFieldValue);
    _verifyPasswordController.addListener(_updateHasTextFieldValue);
  }

  void _updateHasTextFieldValue() {
    setState(() {
      hasTextFieldValue = _passwordController.text.isNotEmpty &&
          _verifyPasswordController.text.isNotEmpty;
    });
  }

  void passwordCheck() {
    if(_passwordController.text != _verifyPasswordController.text){
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("비밀번호를 다시 맞지않습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(context);
              },
              child: Text("확인"),
            ),
          ],
        ),
      );
    } else if(_passwordController.text.length < 8 ) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("비밀번호는 8자리 이상 입력해주세요"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(context);
              },
              child: Text("확인"),
            ),
          ],
        ),
      );
    } else {
      context.read<Register>().password = _passwordController.text;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterNameScreen(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("계정 생성"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "비밀번호를",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                "입력해주세요",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "비밀번호는 8자리 이상이여야 합니다.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                controller: _passwordController,
                hintText: "비밀번호 생성",
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                controller: _verifyPasswordController,
                hintText: "비밀번호 확인",
                obscureText: true,
              ),
              SizedBox(
                height: 55,
              ),
              CustomTextButton(
                onPressed: hasTextFieldValue ? passwordCheck : null,
                backgroundColor: hasTextFieldValue
                    ? PRIMARY_COLOR
                    : PRIMARY_COLOR.withOpacity(0.15),
                foregroundColor: Colors.white,
                width: double.infinity,
                height: 45,
                buttonText: "다음으로",
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("이미 계정이 있으신가요?"),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (){
                      print("로그인ㅋ");
                    },
                    child: Text("로그인", style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
