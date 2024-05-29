import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/utils/secure_storage.dart';
import 'package:provider/provider.dart';

import '../utils/provider_state.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ip = dotenv.get("SERVER_URL");

  void logout(context) async {
    await storage.delete(key: ACCESS_TOKEN_KEY);
    await storage.delete(key: REFRESH_TOKEN_KEY);

    Navigator.pushNamedAndRemoveUntil(
      context,
      'login',
          (route) => false,
    );
  }

  Future getUserInfo() async {
    final dio = Dio();
    String? token = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      Response response = await dio.get(
        "$ip/api/user/profile",
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future getCourseList({required BuildContext context}) async {
    final dio = Dio();
    String? token = await storage.read(key: ACCESS_TOKEN_KEY);
    final tour = context.read<TourTitle>().title;

    try {
      Response response = await dio.get("$ip/api/course/list",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }),
          queryParameters: {
            "course_tour": "${tour}",
          });
      return response.data;
    } on DioException catch (e) {
      print(e.response);
      return e.response?.data;
    }
  }

  Future CombineFetch({required BuildContext context}) {
    return Future.wait([getUserInfo(), getCourseList(context: context)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 정보"),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: CombineFetch(context: context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("데이터를 불러올 수 없습니다."),
                );
              }

              if (snapshot.hasData) {
                final userInfo = snapshot.data[0]["userInfo"];
                final courseList = snapshot.data[1]["data"];
                // 총 퍼센트
                final percentage = courseList.length;
                // 퍼센트 게이지
                final percentageGauge =
                    courseList.where((e) => e["visited"] == 1).length;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 4, color: PRIMARY_COLOR),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        "${userInfo["user_profile"]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 165,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${userInfo["user_name"]} 님",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (courseList.isNotEmpty)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 5,
                                                  color: GRAY,
                                                ),
                                                Container(
                                                  width: percentageGauge /
                                                      percentage *
                                                      165,
                                                  height: 6,
                                                  color: Colors.green,
                                                )
                                              ],
                                            ),
                                          ),
                                        if (courseList.isNotEmpty)
                                          SizedBox(
                                            height: 10,
                                          ),
                                        courseList.isNotEmpty
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "현재 진행중인 투어",
                                                    style: TextStyle(
                                                        color: PRIMARY_COLOR),
                                                  ),
                                                  Text(
                                                      "${((percentageGauge / percentage * 100)).toInt()}%")
                                                ],
                                              )
                                            : Text(
                                                "진행중인 투어가 없습니다.",
                                                style: TextStyle(
                                                    color: PRIMARY_COLOR),
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 4,
                                            offset: Offset(0, 2))
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              child: InkWell(
                                                onTap: () {
                                                  print("안녕");
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Icon(
                                                              CupertinoIcons
                                                                  .gear_alt),
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              color: GRAY,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "프로필 수정",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(CupertinoIcons
                                                        .right_chevron)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 40,
                                              child: InkWell(
                                                onTap: () {
                                                  print("안녕");
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Icon(
                                                              Icons.history),
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              color: GRAY,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "나의 활동",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(CupertinoIcons
                                                        .right_chevron)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 4,
                                          offset: Offset(0, 2))
                                    ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              child: InkWell(
                                                onTap: () {
                                                  logout(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Icon(Icons
                                                              .logout_rounded),
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              color: GRAY,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "로그아웃",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(CupertinoIcons
                                                        .right_chevron)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container();
            }),
      ),
    );
  }
}
