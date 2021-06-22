import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/home/home.dart';

User? mUser;
String? currentUserId;
String? phoneNumber;

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  final FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //get the current user
  getCurrentUser() {
    User? user = mAuth.currentUser;
    if (user != null) {
      //check if user has profile details
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
      phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      print("Current id: $currentUserId \n Phone number : $phoneNumber");

      setState(() {
        mUser = user;
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
            child: Scaffold(body: mUser != null ? Home() : RegistrationPage())),
      ),
    );
  }
}
