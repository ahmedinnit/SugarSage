import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';
  String _username = '';
  String _profilePicture = '';
  String _token = '';
  double _height = 0.0;
  double _weight = 0.0;

  String get userId => _userId;
  String get username => _username;
  String get profilePicture => _profilePicture;
  String get token => _token;
  double get height => _height;
  double get weight => _weight;

  void setUser(String userId, String username, String profilePicture, String token) {
    _userId = userId;
    _username = username;
    _profilePicture = profilePicture;
    _token = token;
    notifyListeners();
  }

  void setHeightAndWeight(double height, double weight) {
    _height = height;
    _weight = weight;
    notifyListeners();
  }

  void clearUser() {
    _userId = '';
    _username = '';
    _profilePicture = '';
    _token = '';
    _height = 0.0;
    _weight = 0.0;
    notifyListeners();
  }
}
