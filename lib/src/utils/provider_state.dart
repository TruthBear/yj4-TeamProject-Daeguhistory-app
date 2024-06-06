import 'package:flutter/cupertino.dart';

// 투어 타이틀
class TourTitle with ChangeNotifier {
  String? _title;

  String? get title => _title;

  set setTitle(String? title) {
    _title = title;
    notifyListeners();
  }
}


// 투어 위도경도
class TourLatLng with ChangeNotifier {
  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  set setLatitude(double? value) {
    _latitude = value;
    notifyListeners();
  }

  set setLongitude(double? value) {
    _longitude = value;
    notifyListeners();
  }
}


//회원가입 정보
class Register extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _name = "";

  String get email => _email;

  String get password => _password;

  String get name => _name;

  void set email(String input_email) {
    _email = input_email;
    notifyListeners();
  }

  void set password(String input_password) {
    _password = input_password;
    notifyListeners();
  }

  void set name(String input_name) {
    _name = input_name;
    notifyListeners();
  }
}