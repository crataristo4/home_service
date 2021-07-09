import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/service/admob_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/options_page.dart';
import 'package:home_service/ui/views/home/artwork.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/bookings/user_booking_page/user_booking_page.dart';
import 'package:home_service/ui/views/home/category.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

CollectionReference usersDbRef = FirebaseFirestore.instance.collection("Users");
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  static const routeName = '/homePage';
  final int? tabIndex;

  Home({Key? key, required this.tabIndex}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? message, nameFromPrefs, imageFromPrefs;
  AdmobService _admobService = AdmobService();

  @override
  void initState() {
    getCurrentUser();
    greetingMessage();

    _tabController = TabController(length: 3, vsync: this);
    _tabController!.index = widget.tabIndex!;

    super.initState();
    _admobService.createInterstitialAd();
  }

  Future<void> getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      getUserType = prefs.getString('userType');

      if (prefs.containsKey('name') & prefs.containsKey('photoUrl')) {
        userName = prefs.getString('name');
        imageUrl = prefs.getString('photoUrl');
      }

      if (prefs.containsKey('category') & prefs.containsKey('expLevel')) {
        category = prefs.getString('category');
        expLevel = prefs.getString('expLevel');
      }

      if (currentUserId != null) {
        //check the state of users / artisans if the user exists
        //check the database if user has details
        await usersDbRef
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
              await usersDbRef.doc(currentUserId).delete().whenComplete(() {
                //delete image from storage
                firebase_storage.Reference deleteProfilePhoto = firebase_storage
                    .FirebaseStorage.instance
                    .refFromURL(imageUrl!);
                deleteProfilePhoto.delete();
                pushToCompleteProfile();
              });
            } else {
              //if true  ... shared pref keys for user name and photoUrl can be null so get data
              if (getUserType == artisan) {
                setState(() {
                  category = documentSnapshot.get(FieldPath(['category']));
                  expLevel = documentSnapshot.get(FieldPath(['expLevel']));
                });
              }

              setState(() {
                userName = documentSnapshot.get(FieldPath(['name']));
                imageUrl = documentSnapshot.get(FieldPath(['photoUrl']));
              });

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

      }
    } catch (error) {
      print("Error on HOme state : $error");
    }
  }

  //push to complete profile when user has no record
  pushToCompleteProfile() async {
    await new Future.delayed(Duration(seconds: 0));
    Navigator.of(context).pushReplacementNamed(CompleteProfile.routeName);
  }

  //greeting message to user
  greetingMessage() {
    var timeNow = DateTime.now().hour;
    if (timeNow < 12) {
      setState(() {
        message = goodMorning;
      });
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      setState(() {
        message = goodAfternoon;
      });
    } else if ((timeNow > 16) && (timeNow <= 20)) {
      setState(() {
        message = goodEvening;
      });
    } else {
      setState(() {
        message = goodNight;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
     Timer(Duration(seconds: 10), () {
        _admobService.showInterstitialAd();
    });

    return WillPopScope(
      onWillPop: () async {
        if (_tabController!.index == 0 || _tabController!.index == 2) {
          _tabController!.index = 1;
          return false;
        } else {
          if (_tabController!.index == 1) return true;
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: //user profile image
              StreamBuilder<DocumentSnapshot>(
                  stream: usersDbRef.doc(currentUserId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: eightDp, top: tenDp),
                        child: CircularProgressIndicator(
                          strokeWidth: 0.5,
                          color: Colors.black45,
                          backgroundColor: Colors.indigoAccent,
                        ),
                      );
                    } else if (!snapshot.data!.exists) {
                      return Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: eightDp, top: tenDp),
                        child: CircularProgressIndicator(
                          strokeWidth: 0.5,
                          color: Colors.black45,
                          backgroundColor: Colors.indigoAccent,
                        ),
                      );
                    }

                    var userDocument = snapshot.data;
                    imageUrl = userDocument!['photoUrl'];
                    userName = userDocument['name'];
                    if (type == artisan) {
                      category = userDocument['category'];
                      expLevel = userDocument['expLevel'];
                    }

                    return GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => OptionsPage()),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: eightDp, top: tenDp),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(30)),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
          title: Container(
            margin: EdgeInsets.only(top: tenDp),
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(eightDp),
            ),
            child: TabBar(
              controller: _tabController,
              // give the indicator a decoration (color and border radius)
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(eightDp),
                color: Colors.indigo,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF757575),
              tabs: [
                Tab(
                  text: Artwork,
                ),
                Tab(
                  text: Artisanz,
                ),
                Tab(
                  text: Bookingz,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //display greeting message to user
            Container(
              margin: EdgeInsets.only(top: eightDp),
              child: Padding(
                padding: EdgeInsets.only(top: tenDp, left: sixteenDp),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.indigo,
                  child: Text(
                    "$message ${userName ?? ''}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ArtworksPage(),
                  CategoryPage(),
                  getUserType == user ? UserBookingsPage() : BookingPage()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
