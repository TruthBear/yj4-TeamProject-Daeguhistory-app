import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/views/login_and_register/register_password_screen.dart';
import 'package:project/src/weiget/custom_text_button.dart';
import 'package:project/src/weiget/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../utils/provider_state.dart';


class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({super.key});

  @override
  State<RegisterEmailScreen> createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {
  TextEditingController _controller = TextEditingController();
  bool hasTextFieldValue = false;
  bool emailValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(_updateHasTextFieldValue);
  }

  void _updateHasTextFieldValue() {
    setState(() {
      hasTextFieldValue = _controller.text.isNotEmpty;
    });
  }


  void emailCheck() async {

    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_controller.text);

    if(!emailValid){
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("이메일 형식에 맞게 입력해주세요"),
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
      if(emailValid){
        final dio = Dio();
        final ip = dotenv.get("SERVER_URL");
        try {
          Response response = await dio.post(
            '$ip/api/user/email-check',
            data: {
              "email": _controller.text,
            },
          );
          
          context.read<Register>().email = _controller.text;
          
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPasswordScreen(),));

        } on DioException catch (e) {
          if (e.response != null) {
            print(e.response?.statusCode);
            print(e.response?.data["message"]);
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("중복된 이메일입니다."),
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
          }
        }
      }
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
                "이메일을",
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
                "투어를 시작하려면 이메일을 입력해 주세요",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                controller: _controller,
                hintText: "이메일을 입력해주세요",
              ),
              SizedBox(
                height: 110,
              ),
              CustomTextButton(
                onPressed: hasTextFieldValue ? emailCheck : null,
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
