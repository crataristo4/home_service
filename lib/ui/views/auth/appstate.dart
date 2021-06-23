import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/home/home.dart';

String? currentUserId;
String? phoneNumber;

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  final mAuth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //get the current user id and phone number
  getCurrentUser() {
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Container(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
                body: currentUserId != null ? Home() : RegistrationPage())),
      ),
    );
  }
}
