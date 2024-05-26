import 'package:flutter/material.dart';
import 'package:project/src/navigation/bottom_navigation_items.dart';
import 'package:project/src/views/dictionary_screen.dart';
import 'package:project/src/views/home_screen.dart';
import 'package:project/src/views/login_and_register/select_login_screen.dart';
import 'package:project/src/views/qr_screen.dart';
import 'package:project/src/views/splash_screen.dart';
import 'package:project/src/views/stamp_screen.dart';
import 'package:project/src/views/user_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'splash',
      routes: {
        '/': (context) => DefalutLayout(),
        'splash': (context) => SplashScreen(),
        'login': (context) => SelectLoginScreen(),
      },
    );
  }
}

class DefalutLayout extends StatefulWidget {
  const DefalutLayout({super.key});

  @override
  State<DefalutLayout> createState() => _DefalutLayoutState();
}

class _DefalutLayoutState extends State<DefalutLayout> {
  PageController _pageController = PageController();
  int _currentIndex = 1;

  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Screens.elementAt(currentIndex),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          HomeScreen(),
          DictionaryScreen(),
          QrScreen(onChanged: () { changeIndex(3); },),
          StampScreen(),
          UserScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
