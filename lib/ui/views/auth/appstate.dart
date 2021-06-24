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
    //get current userId and phone number
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

    if (currentUserId != null) {
      //check the state of users / artisans if the user exists
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //get data from shared preferences
      getUserType = prefs.getString("userType");
      userName = prefs.getString('name');
      imageUrl = prefs.getString('photoUrl');

      //check the database if user has details
      await usersDbRef
          .doc(currentUserId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          //if true do nothing ...

        } else {
          //if not then clear shared preference data and navigate to complete profile
          await new Future.delayed(Duration(seconds: 0));
          prefs.remove('name');
          prefs.remove('photoUrl');

          Navigator.of(context).restorablePushNamed(CompleteProfile.routeName);
        }
      }).catchError((onError) {
        debugPrint("Error: $onError");
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
                body: currentUserId != null ||
                        imageUrl != null ||
                        userName != null
                    ? Home(
                        name: userName,
                        image: imageUrl,
                      )
                    : RegistrationPage())),
      ),
    );
  }
}
