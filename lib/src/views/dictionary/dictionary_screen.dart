import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/views/dictionary/dictionary_detail_screen.dart';
import '../../utils/secure_storage.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String text = "";

  Future<Map<String, dynamic>> getCourseList() async {
    final dio = Dio();
    final ip = dotenv.get("SERVER_URL");
    String? token = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      Response response = await dio.get("$ip/api/course/list",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }),
          queryParameters: {
            "course_tour": "극장",
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
        title: Text("대구의 옛 극장들"),
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
              if (snapshot.hasData) {
                List<dynamic> result = snapshot.data!["data"];
                return ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      print("스탭바이 스탭");
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: SizedBox(
                          height: 100,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DictionaryDetailScreen(
                                      title: result[index]["course_name"]),
                                ),
                              );
                            },
                            label: Text(
                              "${result[index]["course_name"]}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )),
                          ),
                        )),
                  ),
                );
              }

              return Container();
            }),
      ),
    );
  }
}
