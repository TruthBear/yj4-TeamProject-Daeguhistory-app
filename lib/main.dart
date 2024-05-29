import 'package:flutter/material.dart';
import 'package:project/src/utils/provider_state.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TourTitle(),
        ),
        ChangeNotifierProvider(
          create: (context) => TourLatLng(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
