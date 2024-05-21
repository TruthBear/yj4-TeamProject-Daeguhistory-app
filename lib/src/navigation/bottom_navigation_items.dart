import 'package:flutter/material.dart';
import 'package:project/src/views/dictionary_screen.dart';
import 'package:project/src/views/home_screen.dart';
import 'package:project/src/views/qr_screen.dart';
import 'package:project/src/views/stamp_screen.dart';
import 'package:project/src/views/user_screen.dart';

const List<Widget> Screens = [
  HomeScreen(),
  DictionaryScreen(),
  QrScreen(),
  StampScreen(),
  UserScreen(),
];

const List<BottomNavigationBarItem> BottomNavigationItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: '홈',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.menu_book),
    label: '사전',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.qr_code),
    label: 'qr코드',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.map_rounded),
    label: '스탬프',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: '내정보',
  ),
];