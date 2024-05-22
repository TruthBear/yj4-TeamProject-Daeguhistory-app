import 'package:flutter/material.dart';
import 'package:project/src/navigation/bottom_navigation_items.dart';
import 'package:project/src/views/login_screen.dart';
import 'package:project/src/views/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'splash',
      routes: {
        '/': (context) => DefalutLayout(),
        'splash': (context) => SplashScreen(),
        'login': (context) => LoginScreen(),
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
  int _currentIndex = 1;

  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Screens.elementAt(_currentIndex),
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
