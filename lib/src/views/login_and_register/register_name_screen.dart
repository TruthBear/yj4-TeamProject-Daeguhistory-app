import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/provider_state.dart';
import '../../utils/secure_storage.dart';
import '../../weiget/custom_text_button.dart';
import '../../weiget/custom_text_form_field.dart';

class RegisterNameScreen extends StatefulWidget {
  const RegisterNameScreen({super.key});

  @override
  State<RegisterNameScreen> createState() => _RegisterNameScreenState();
}

class _RegisterNameScreenState extends State<RegisterNameScreen> {

  TextEditingController _controller = TextEditingController();
  bool hasTextFieldValue = false;


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


  void register() async {
    final dio = Dio();
    final ip = dotenv.get("SERVER_URL");

    print(context.read<Register>().email);
    print(context.read<Register>().password);
    print(_controller.text);

    try {
      Response response = await dio.post(
        '$ip/api/user/register',
        data: {
          "email": "${context.read<Register>().email}",
          "password": "${context.read<Register>().password}",
          "name": "${_controller.text}",
        },
      );


      print(response.data);

      String accessToken = response.data["data"]["accessToken"];
      String refreshToken = response.data["data"]["refreshToken"];

      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("회원가입이 완료되었습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              },
              child: Text("확인"),
            ),
          ],
        ),
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
                "닉네임을",
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
                "닉네임은 다른 사용자에게 표시됩니다.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                controller: _controller,
                hintText: "이름을 입력해주세요",
              ),
              SizedBox(
                height: 110,
              ),
              CustomTextButton(
                onPressed: hasTextFieldValue ? register : null,
                backgroundColor: hasTextFieldValue
                    ? PRIMARY_COLOR
                    : PRIMARY_COLOR.withOpacity(0.15),
                foregroundColor: Colors.white,
                width: double.infinity,
                height: 45,
                buttonText: "회원가입",
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
