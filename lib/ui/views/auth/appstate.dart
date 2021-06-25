import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
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

  getCurrentUser() async {
    try {
      //get current userId and phone number
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
      phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

      if (currentUserId != null) {
        //check the state of users / artisans if the user exists
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //get data from shared preferences
        if (prefs.containsKey("userType")) {
          getUserType = prefs.getString("userType");
        }
        if (prefs.containsKey('name') && prefs.containsKey('photoUrl')) {
          userName = prefs.getString('name');
          imageUrl = prefs.getString('photoUrl');
          print("Username from shared pref is: $userName");
        } else {
          print("Username from empty Shared pref is: $userName");

          //check the database if user has details
          await usersDbRef
              .doc(currentUserId)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              //if true  ... shared pref keys for user name and photoUrl can be null so get data
              if (getUserType == user) {
                userName = documentSnapshot.get(FieldPath(['userName']));
              } else if (getUserType == artisan) {
                userName = documentSnapshot.get(FieldPath(['artisanName']));
              }
              imageUrl = documentSnapshot.get(FieldPath(['photoUrl']));
            } else {
              //if not then navigate to complete profile
              await new Future.delayed(Duration(seconds: 0));
              //prefs.remove('name');
              // prefs.remove('photoUrl');

              Navigator.of(context)
                  .restorablePushNamed(CompleteProfile.routeName);
            }
          }).catchError((onError) {
            debugPrint("Error: $onError");
          });
        }
      }
    } catch (error) {
      print("Error on App state : $error");
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
