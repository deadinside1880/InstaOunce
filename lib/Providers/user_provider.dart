import 'package:flutter/material.dart';
import 'package:shron/models/user.dart';
import 'package:shron/resources/auth.dart';

class UserProvider extends ChangeNotifier {
  final AuthFunctions _authFunctions = AuthFunctions();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authFunctions.getUserDetails();

    _user = user;

    notifyListeners();
  }
}
