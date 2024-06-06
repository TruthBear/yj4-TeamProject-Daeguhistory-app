import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/utils/provider_state.dart';
import 'package:project/src/views/stamp/qr_screen.dart';
import 'package:project/src/weiget/custom_text_button.dart';
import 'package:provider/provider.dart';

import '../../utils/secure_storage.dart';

class StampScreen extends StatefulWidget {
  const StampScreen({super.key});

  @override
  State<StampScreen> createState() => _StampScreenState();
}

class _StampScreenState extends State<StampScreen> {
  late final GoogleMapController _controller;
  StreamSubscription<Position>? _positionStreamSubscription;
  List<dynamic> courseList = [];
  final Map<String, bool> canQrCheck = {};
  final Map<String, bool> qrCheckDone = {};
  List<dynamic> currentCourse = [];
  String? currentAdress = "";
  final double okDistance = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((event) {
          final cureentLocation = LatLng(event.latitude, event.longitude);
          courseList.forEach((course) {
            print(course);
            final courseLocation = LatLng(
              double.parse(course["course_latitude"]),
              double.parse(course["course_longitude"]),
            );
            final distance = Geolocator.distanceBetween(
              cureentLocation.latitude,
              cureentLocation.longitude,
              courseLocation.latitude,
              courseLocation.longitude,
            );

            setState(() {
              if (distance > okDistance) {
                canQrCheck[course["course_name"]] = false;
              } else {
                canQrCheck[course["course_name"]] = true;
              }
            });
          });
        });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel(); // Stream 구독 취소
    super.dispose();
  }

  Future checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      throw Exception("위치 기능을 활성화 해주세요.");
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
    }

    if (checkedPermission != LocationPermission.always &&
        checkedPermission != LocationPermission.whileInUse) {
      throw Exception('위치 권환을 허가 해주세요');
    }
  }

  Future getCourseList() async {
    final dio = Dio();
    final ip = dotenv.get("SERVER_URL");
    final tour = context.watch<TourTitle>().title;
    String? token = await storage.read(key: ACCESS_TOKEN_KEY);
    try {
      Response response = await dio.get("$ip/api/course/list",
          options: Options(headers: {
            "Authorization":
            "Bearer $token",
          }),
          queryParameters: {
            "course_tour": "$tour",
          });
      return response.data["data"];
    } on DioException catch (e) {
      return e.response?.data["data"];
    }
  }

  Future<String> getAdress({required double lat, required double lng}) async {
    if (lat == null || lng == null) {
      return "주소를 불러올 수 없습니다.";
    }

    final dio = Dio();
    final apiKey = dotenv.get("GOOGLE_API_KEY");
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey&language=ko";
    try {
      Response response = await dio.get(url);
      return response.data["results"][0]["formatted_address"].toString();
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<Map<String, BitmapDescriptor>> customMarker() async {
    BitmapDescriptor redMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/red_marker.png");

    BitmapDescriptor grayMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/gray_marker.png");

    return {"red": redMarker, "gray": grayMarker};
  }

  Future getCurrentCourse() async {
    return courseList
        .where((course) => canQrCheck[course["course_name"]] == true)
        .toList();
  }

  bool canAnyQrCheck() {
    return canQrCheck.values.any((element) => element == true);
  }

  Future combineFetch() {
    return Future.wait([
      checkPermission(),
      getCourseList(),
      customMarker(),
      getCurrentCourse()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              context.watch<TourTitle>().title == null
                  ? "투어를 선택해주세요"
                  : "현재 진행중인 투어",
              style: TextStyle(color: PRIMARY_COLOR, fontSize: 12),
            ),
            context.watch<TourTitle>().title == null
                ? Container()
                : Text("${context.watch<TourTitle>().title}")
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final location = await Geolocator.getCurrentPosition();
              _controller.animateCamera(CameraUpdate.newLatLng(
                  LatLng(location.latitude, location.longitude)));
            },
            icon: Icon(Icons.gps_fixed_rounded),
            color: PRIMARY_COLOR,
          )
        ],
      ),
      body: FutureBuilder(
          future: combineFetch(),
          builder: (context, snapshot) {
            if (context.read<TourLatLng>().latitude == null) {
              return Center(
                child: Text("투어를 선택해주세요"),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("데이터를 받아올 수 없습니다."),
              );
            }

            if (snapshot.hasData) {
              courseList = snapshot.data[1];
              final customMarker = snapshot.data[2];
              currentCourse = snapshot.data[3];

              final List<Marker> courseMarkers = courseList
                  .map(
                    (e) => Marker(
                    markerId: MarkerId(e["course_name"]),
                    position: LatLng(
                      double.parse(e["course_latitude"]),
                      double.parse(e["course_longitude"]),
                    ),
                    infoWindow: InfoWindow(
                      title: e["course_name"],
                    ),
                    icon: e["visited"] == 1
                        ? customMarker["red"]
                        : customMarker["gray"],
                    onTap: () {
                      print(e["course_name"]);
                    }),
              )
                  .toList();

              final List<Circle> courseCircles = courseList
                  .map((e) => Circle(
                circleId: CircleId(e["course_name"]),
                center: LatLng(
                  double.parse(e["course_latitude"]),
                  double.parse(e["course_longitude"]),
                ),
                radius: okDistance,
                fillColor: e["visited"] == 1
                    ? Colors.blue.withOpacity(0)
                    : Colors.blue.withOpacity(0.2),
                strokeColor: e["visited"] == 1
                    ? Colors.blue.withOpacity(0)
                    : Colors.blue.withOpacity(0.7),
                strokeWidth: e["visited"] == 1 ? 0 : 4,
              ))
                  .toList();

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                            context.read<TourLatLng>().latitude!,
                            context.read<TourLatLng>().longitude!,
                          ),
                          zoom: 15),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      markers: {...courseMarkers},
                      circles: {...courseCircles},
                    ),
                  ),
                  if (canAnyQrCheck() && currentCourse.isNotEmpty)
                    Positioned(
                      child: Container(
                        width: double.infinity,
                        height: 170,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${currentCourse[0]["course_name"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      FutureBuilder<String>(
                                          future: getAdress(
                                            lat: double.parse(currentCourse[0]
                                            ["course_latitude"]),
                                            lng: double.parse(currentCourse[0]
                                            ["course_longitude"]),
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text("데이터를 불러오지 못했습니다.");
                                            }
                                            if (snapshot.hasData) {
                                              return Text(
                                                "${snapshot.data}",
                                                style: TextStyle(fontSize: 16),
                                              );
                                            }
                                            return Text("주소 불러오는 중...");
                                          })
                                    ],
                                  ),
                                  Image.asset(currentCourse[0]["visited"] == 1
                                      ? "assets/red_stamp.png"
                                      : "assets/gray_stamp.png"),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              CustomTextButton(
                                onPressed: currentCourse[0]["visited"] == 1
                                    ? null
                                    : () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => QrScreen(
                                        courseName: currentCourse[0][
                                        "course_name"]),
                                  ));
                                },
                                width: double.infinity,
                                height: 45,
                                buttonText: currentCourse[0]["visited"] == 1
                                    ? "방문한 장소입니다."
                                    : "qr코드 스캔",
                                backgroundColor: currentCourse[0]["visited"] == 1
                                    ? PRIMARY_COLOR.withOpacity(0.15)
                                    : PRIMARY_COLOR,
                                foregroundColor: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("로딩중"),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
