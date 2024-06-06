import 'package:flutter/material.dart';
import 'package:project/src/navigation/bottom_navigation_items.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/views/dictionary/dictionary_screen.dart';
import 'package:project/src/views/home_screen.dart';
import 'package:project/src/views/login_and_register/select_login_screen.dart';
import 'package:project/src/views/splash_screen.dart';
import 'package:project/src/views/stamp/stamp_screen.dart';
import 'package:project/src/views/stamp/test.dart';
import 'package:project/src/views/user_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        '/': (context) => DefalutLayout(),
        'splash': (context) => SplashScreen(),
        'login': (context) => SelectLoginScreen(),
        'test' : (context) => TestMap(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: BACKGROUND_COLOR,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: BACKGROUND_COLOR,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black
          )
        ),
      ),
    );
  }
}

class DefalutLayout extends StatefulWidget {
  const DefalutLayout({super.key});

  @override
  State<DefalutLayout> createState() => _DefalutLayoutState();
}

class _DefalutLayoutState extends State<DefalutLayout> {
  int _currentIndex = 0;

  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(),
        DictionaryScreen(),
        StampScreen(),
        UserScreen(),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: changeIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: BottomNavigationItems,
      ),
    );
  }
}
