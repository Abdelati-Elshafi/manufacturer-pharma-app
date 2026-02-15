import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _mainpageloadingvisible = false;
  bool get mainpageloadingvisible => _mainpageloadingvisible;
  set mainpageloadingvisible(bool value) {
    _mainpageloadingvisible = value;
  }

  String _usernmame = '';
  String get usernmame => _usernmame;
  set usernmame(String value) {
    _usernmame = value;
  }

  String _userRole = '';
  String get userRole => _userRole;
  set userRole(String value) {
    _userRole = value;
  }
}
