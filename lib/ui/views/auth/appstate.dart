import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? currentUserId;
String? phoneNumber;
String? name;
String? photoUrl;

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
  getCurrentUser() async {
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

    if (currentUserId != null) {
      //method to check the state of users / artisans
      SharedPreferences prefs = await SharedPreferences.getInstance();
      getUserType = prefs.getString("userType");

      await new Future.delayed(Duration(seconds: 0));
      await usersDbRef
          .doc(currentUserId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          userName = prefs.getString('name');
          imageUrl = prefs.getString('photoUrl');

          print("Name is : $userName \nPhoto url : - $imageUrl");
        } else {
          Navigator.of(context).restorablePushNamed(CompleteProfile.routeName);
        }
      }).catchError((onError) {
        debugPrint("Error: $onError");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async => true,
            child: Container(
              child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                      body:
                          currentUserId != null ? Home() : RegistrationPage())),
            ),
          );
        });
  }
}
