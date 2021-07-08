import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/views/auth/register.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? currentUserId;
String? phoneNumber;
String? userName;
String? type;
String? category;
String? expLevel;
String? getUserType;
String? imageUrl;

//loading key
final GlobalKey<State> loadingKey = new GlobalKey<State>();
final DateTime timeStamp = DateTime.now();

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  final mAuth = FirebaseAuth.instance;
  int? tabIndex = 1;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  //todo -- check why username and photo does not load on fresh install
  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      getUserType = prefs.getString('userType');
      //get current userId and phone number
      setState(() {
        currentUserId = FirebaseAuth.instance.currentUser!.uid;
        phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      });

      if (currentUserId != null) {
        //check the state of users / artisans if the user exists
        //check the database if user has details
        usersDbRef
            .doc(currentUserId)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            //delete user details in-case user type changes and complete profile
            //this could happen if the user re-installs the app and selects a different account type which is different from value in the database
            type = documentSnapshot.get(FieldPath(['type']));

            if (getUserType == user && type == artisan ||
                getUserType == artisan && type == user) {
              //delete user record
              await usersDbRef
                  .doc(currentUserId)
                  .delete()
                  .then((value) {})
                  .then((value) {
                //delete image from storage
                firebase_storage.Reference deleteProfilePhoto = firebase_storage
                    .FirebaseStorage.instance
                    .refFromURL(imageUrl!);
                deleteProfilePhoto.delete();
              }).whenComplete(() => //then navigate to complete profile
                      pushToCompleteProfile());
            } else {
              //if true  ... shared pref keys for user name and photoUrl can be null so get data
              if (getUserType == artisan) {
                category = documentSnapshot.get(FieldPath(['category']));
                expLevel = documentSnapshot.get(FieldPath(['expLevel']));
              }

              userName = documentSnapshot.get(FieldPath(['name']));
              imageUrl = documentSnapshot.get(FieldPath(['photoUrl']));

              //put values into shared pref to avoid null values
              prefs.setString("name", userName!);
              prefs.setString("photoUrl", imageUrl!);
              prefs.setString("category", category!);
              prefs.setString("expLevel", expLevel!);
            }
          } else {
            //if not then navigate to complete profile
            pushToCompleteProfile();
          }
        }).catchError((onError) {
          debugPrint("Error: $onError");
        });

//------------------------------------------------------------------------------------------------
        /*     if (getUserType == artisan &&
            prefs.containsKey('name') &&
            prefs.containsKey('photoUrl') &&
            prefs.containsKey('category') &&
            prefs.containsKey('expLevel')) {
          //get data from shared preferences

          userName = prefs.getString('name');
          imageUrl = prefs.getString('photoUrl');
          getUserType = prefs.getString('userType');
          category = prefs.getString('category');
          expLevel = prefs.getString('expLevel');

          print(
              "Username from shared pref is: $userName , type is $getUserType , category is $category , experience level is $expLevel");
        } else if (getUserType == user &&
            prefs.containsKey('name') &&
            prefs.containsKey('photoUrl')) {
          userName = prefs.getString('name');
          imageUrl = prefs.getString('photoUrl');
          print(
              "Username from shared pref is: $userName , type is $getUserType ");
        } else {
          print(
              "Username from empty Shared pref is: $userName and type is $getUserType");


        }*/
      }
    } catch (error) {
      print("Error on App state : $error");
    }
  }

  pushToCompleteProfile() async {
    await new Future.delayed(Duration(seconds: 0));
    Navigator.of(context).pushReplacementNamed(CompleteProfile.routeName);
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
                        userName != null ||
                        category != null ||
                        expLevel != null
                    ? Home(
                  tabIndex: tabIndex! == 0 || tabIndex! == 2
                            ? tabIndex = 1
                            : tabIndex = 1,
                      )
                    : RegistrationPage())),
      ),
    );
  }
}
