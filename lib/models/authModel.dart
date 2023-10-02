import 'package:dropsride/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isOnline = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isOnline => _isOnline;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<bool> get authStream => _auth.authStateChanges().map((user) => user != null);

  AuthModel() {
    // Listen for auth state changes
    authStream.listen((loggedIn) {
      _isLoggedIn = loggedIn;
      _isOnline = loggedIn;
      notifyListeners();
    });
  }
}
