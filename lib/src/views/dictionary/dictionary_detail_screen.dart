import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/views/dictionary/dictionary_webview.dart';
import 'package:project/src/weiget/custom_text_button.dart';
import '../../utils/secure_storage.dart';

class DictionaryDetailScreen extends StatefulWidget {
  final String title;

  const DictionaryDetailScreen({
    super.key,
    required this.title,
  });

  @override
  State<DictionaryDetailScreen> createState() => _DictionaryDetailScreenState();
}

class _DictionaryDetailScreenState extends State<DictionaryDetailScreen> {
  late String url;

  Future<Map<String, dynamic>> getCourseList() async {
    final dio = Dio();
    final ip = dotenv.get("SERVER_URL");
    String? token = await storage.read(key: ACCESS_TOKEN_KEY);
    try {
      Response response = await dio.get("$ip/api/course/deatil",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }),
          queryParameters: {
            "course_name": "${widget.title}",
          });
      return response.data;
    } on DioException catch (e) {
      return e.response?.data["data"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}",),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getCourseList(),
          builder: (context, snapshot) {

            if (snapshot.hasError) {
              return Center(
                child: Text("데이터를 받아올 수 없습니다."),
              );
            }

            if(snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: GRAY,
                width: double.infinity,
                height: 300,
              );
            }

            if (snapshot.hasData) {
              final Map<String, dynamic> result = snapshot.data!["data"][0];
              // print(result);
              final String title = result["course_name"];
              final List<String> description =
              result["course_description"].toString().split("\\n");
              final List<Widget> textWidgets = description
                  .map(
                    (e) =>
                    Text(
                      e,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
              )
                  .toList();
              final String image_url = result["course_image"];
              final String web_url = result["course_url"];
              url = web_url;
              // print(description);
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.network(image_url),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 30, bottom: 120),
                        child: Column(
                          children: [
                            ...textWidgets,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container(
              color: GRAY,
              width: double.infinity,
              height: 300,
            );
          },
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: BACKGROUND_COLOR,
          border: Border(
            top: BorderSide(
              width: 1,
              color: GRAY,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: CustomTextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DictionaryWebview(url: url)),);
            },
            backgroundColor: PRIMARY_COLOR,
            foregroundColor: Colors.white,
            width: double.infinity,
            height: 45,
            buttonText: "자세히 알아보기",
          ),
        ),
      ),
    );
  }
}
