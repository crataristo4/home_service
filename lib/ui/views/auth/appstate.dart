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
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //get the current user
  getCurrentUser() {
    FirebaseAuth mAuth = FirebaseAuth.instance;
    User? users = mAuth.currentUser;
    if (users != null) {
      setState(() {
        currentUserId = FirebaseAuth.instance.currentUser!.uid;
        phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      });
    }
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
                body: FirebaseAuth.instance != null
                    ? Home()
                    : RegistrationPage())),
      ),
    );
  }
}
